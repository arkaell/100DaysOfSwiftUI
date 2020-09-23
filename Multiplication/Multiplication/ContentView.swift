//
//  ContentView.swift
//  Multiplication
//
//  Created by David Liongson on 9/18/20.
//

import SwiftUI

struct ContentView: View {
    
    private let numberOfQuestionsOptions = ["5","10","20","All"]
    
    @State var gameStarted = false
    @State var numberOfQuestions = 0
    @State var questions = [Question]()
    @State var highestMultiplicationTable = 5
    @State var score = 0
    @State var currentQuestion = 0
    @State var currentAnswer: String = ""
    
    var body: some View {
        Group {
            if !gameStarted {
                Form {
                    Section(header: Text("Game Settings")) {
                        HStack {
                            Spacer()
                            Button("Begin Game") {
                                startGame()
                            }
                            Spacer()
                        }
                    }
                    
                    Section(header: Text("Largest Multiplication Table")) {
                        Stepper("Up to \(highestMultiplicationTable)", value: $highestMultiplicationTable, in: 5...10)
                        
                    }
                    
                    Section(header: Text("Number of Questions")) {
                        Picker(selection: $numberOfQuestions, label: Text("test")) {
                            ForEach(0..<4) {
                                Text("\(numberOfQuestionsOptions[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    if score != 0 {
                        Section(header: Text("Previous score:")) {
                            Text("\(score) out of \(questions.count) correct")
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    HStack {
                        Text("\(questions[currentQuestion].question)")
                            .font(.headline)
                        Spacer()
                        TextField("", text: $currentAnswer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    
                    Spacer()
                    
                    Button("Submit") {
                        
                        guard let answer = Int(currentAnswer) else { return }
                        
                        if answer == questions[currentQuestion].answer {
                            score += 1
                        }

                        if currentQuestion < questions.count - 1{
                            currentQuestion += 1
                        } else {
                            gameStarted.toggle()
                        }
                        
                        currentAnswer = ""
                    }
                    .foregroundColor(.green)
                    .font(.headline)
                    
                    Spacer()
                }
            }
        }
    }
    
    func startGame() {
        
        
        switch numberOfQuestions {
        case 0:
            createQuestions(total: 5)
        case 1:
            createQuestions(total: 10)
        case 2:
            createQuestions(total: 20)
        default:
            // create for ALL
            let total = (highestMultiplicationTable - 1) * 10
            createQuestions(total: total)
        }
        currentAnswer = ""
        currentQuestion = 0
        score = 0
        gameStarted.toggle()
    }
    
    func createQuestions(total number: Int) {
        
        var allQuestions = [Question]()
        
        var index = 2
        
        while(index <= highestMultiplicationTable) {
            var counter = 1
            while(counter <= 10) {
                let question = "What is \(index) x \(counter) = "
                let answer = index * counter
                print("\(question) \(answer)")
                allQuestions.append(Question(question: question, answer: answer))
                counter += 1
            }
            index += 1
        }
        print(allQuestions.count)
        if number == 3 {
            questions = allQuestions.shuffled()
        } else {
            print(allQuestions.count)
            let shuffledQuestions = allQuestions.shuffled()
            questions = shuffledQuestions.dropLast(allQuestions.count - number)
        }
        print(questions.count)
        print(questions)
        
    }
}

struct Question {
    var question: String
    var answer: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
