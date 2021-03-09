//
//  ContentView.swift
//  WordScramble
//
//  Created by David Liongson on 9/8/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State var errorTitle = ""
    @State var errorMessage = ""
    @State var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                GeometryReader { listView in
                    List(usedWords, id: \.self) { word in
                        GeometryReader { wordGeo in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                    .foregroundColor(getColor(wordGeo, listView))
                                Text(word)
                            }
                            .offset(x: calculateOffset(geo: wordGeo, list: listView))
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text("\(word), \(word.count) letters"))
                        }
                    }
                }
                
                
                Text("SCORE: \(score) PTS")
                    .font(.headline)
            }
            .navigationBarTitle("\(rootWord)")
            .navigationBarItems(leading: Button("New Game", action: {
                startGame()
                newWord = ""
                usedWords = [String]()
                score = 0
            }))
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func getColor(_ inner: GeometryProxy, _ outer: GeometryProxy) -> Color {
//        print("index:\(index) = \(inner.frame(in: .global).maxY) / \(outer.size.height)")
        let value = Double(inner.frame(in: .global).maxY / outer.size.height)
                
        var redValue: Double = 0.0
        var greenValue: Double = 0.0
        var blueValue: Double = 0.0
        
        redValue = 0.5 - (value * value) - value
        greenValue = ((value * value) / 2) + (value / 3)
        blueValue = (value * value) + (value / 3)
        
//        if value < 0.34 {
//            redValue = 0.34 - value
//            greenValue = value
//            blueValue = 0
//        } else if value >= 0.34 && value < 0.67 {
//            redValue = 0
//            greenValue = 0.34 - value
//            blueValue = value
//        } else if value >= 0.67 {
//            redValue = value
//            greenValue = 0
//            blueValue = 0.34 - value
//        }
        
        let result: Color = Color(red: redValue, green: greenValue, blue: blueValue)
        return result
    }
    
    func calculateOffset(geo: GeometryProxy, list: GeometryProxy) -> CGFloat {
        var result: CGFloat = 0
        // the offset increases as the number of words increase
        // more words = higher maxY of geo frame
        // get the position of the current geometryproxy relative to the height
        let maxY = geo.frame(in: .global).maxY
        let fullHeight = list.size.height
        let position =  maxY / fullHeight // this should be near 1.0 once more words are entered.
        let listHeight = list.frame(in: .global).height * 1.15

        print("maxY: \(maxY), fullHeight: \(fullHeight), position: \(position), listHeight: \(listHeight)")
        result = max(0, position * (maxY - listHeight))
        print("result: \(result)")
    
        return result
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle")
    }

    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more orignal")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        score += calculateScore(for: answer)
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func calculateScore(for word: String) -> Int {
        let wordLength = word.utf16.count
        return wordLength - 3
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let wordLength = word.utf16.count
        if wordLength <= 3 {
            return false
        } else {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: wordLength)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspelledRange.location == NSNotFound
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

