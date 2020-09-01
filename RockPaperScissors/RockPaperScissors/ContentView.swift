//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by David Liongson on 9/1/20.
//

import SwiftUI

struct ContentView: View {
    
    private let moves = ["Rock", "Paper", "Scissors"]
    private let maxTurns = 10
    @State private var score = 0
    @State private var currentTurn = 1
    @State private var currentMove = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var results = [String]()
    
    
    
    private func getPoints(for move: Int, against currentMove: Int, toWin: Bool) {
        var result = 0
        if toWin {
            if (currentMove == 0 && move == 1)
            || (currentMove == 1 && move == 2)
            || (currentMove == 2 && move == 0){
                result = 1
            }
        } else {
            if (currentMove == 2 && move == 1)
            || (currentMove == 1 && move == 0)
            || (currentMove == 0 && move == 2){
                result = 1
            }
        }
        
        results.append("Got \(result) point for choosing \(moves[move]) to \(moves[currentMove]) to \(toWin ? "win" : "lose").")
        score += result
    }

    
    private func nextTurn() {
        currentMove = Int.random(in: 0...2)
        shouldWin = Bool.random()
        currentTurn += 1
    }
    
    private func newGame() {
        currentTurn = 0
        nextTurn()
    }
    
    var body: some View {
        VStack {
            if (currentTurn > maxTurns) {
                Text("You scored \(score) points!!")
                Button("New Game") {
                    newGame()
                }
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 60, alignment: .center)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .font(.headline)
                .foregroundColor(.white)
                VStack {
                    ForEach(0..<results.count) { result in
                        Text("Turn \(result + 1): \(results[result])")
                            .font(.footnote)
                    }
                }
                .padding(10)
            } else {
                Text("Turn \(currentTurn). The app's move is")
                Text("\(moves[currentMove]) !!")
                    .fontWeight(.bold)
                Text("Choose your move to \(shouldWin ? "win" : "lose")")
                HStack {
                    ForEach(0..<3) { index in
                        Button("I Choose \(moves[index])!") {
                            print("\(moves[index]) vs \(moves[currentMove]), shouldWin = \(shouldWin)")
                            getPoints(for: index, against: currentMove, toWin: shouldWin)
                            nextTurn()
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 60, alignment: .center)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .font(.headline)
                        .foregroundColor(.white)
                    }
                    .padding(10)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
