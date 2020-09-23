//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by David Liongson on 8/23/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State var showingScore = false
    @State var scoreTitle = ""
    
    @State var score = 0
    
    @State private var animationAmount = 0.0
    @State private var enabled = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }, label: {
                        FlagImage(imageName: self.countries[number])
                            
                    })
                    .opacity(enabled && (correctAnswer != number) ? 0.25 : 1.0)
                    .rotation3DEffect(
                        .degrees(animationAmount),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .animation(correctAnswer == number ? .default : nil)
                    
                }
                
                
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            self.animationAmount += 360
            self.enabled.toggle()
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = """
                Sorry, that is the wrong flag.
                You chose the flag of \(countries[number])
                """
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View {
    
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white, lineWidth: 1.5))
            .shadow(color: .black, radius: 2.5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
