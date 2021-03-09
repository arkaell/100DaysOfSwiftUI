//
//  ContentView.swift
//  Slice and Dice
//
//  Created by David Liongson on 2/22/21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        TabView {
            DiceRollView()
                .environment(\.managedObjectContext, moc)
                .tabItem {
                    Label("Roll", systemImage: "die.face.5")
                }
            
            RollHistoryView()
                .environment(\.managedObjectContext, moc)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
    }
    
    
}

struct DiceRollView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var diceInHand = Dice()
    
    @State var isRolling = false
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center) {
                
                Text("Let's Roll!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                if self.isRolling {
                    Text("???")
                        .font(.largeTitle)
                        .italic()
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    Text("You rolled \(diceInHand.result)!")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .padding()
                }
                
                diceInHand.displayImage
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(self.isRolling ? Color.secondary : Color.primary)
                    .frame(maxWidth: geo.size.width)
                    .padding(100)
            
                
                Button(self.isRolling ? "Rolling…" : "Roll") {
                    roll()
                    self.feedback.notificationOccurred(.success)
                }
                .font(.largeTitle)
                .padding()
                .foregroundColor(self.isRolling ? .white : .green)
                .background(self.isRolling ? Color.secondary : Color.primary )
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .disabled(self.isRolling)
                
            }
        }

    }
    
    private func roll() {
                
        self.isRolling = true
        
        for i in stride(from: 0, to: 1.7, by: 0.1) {
            let delay = i * i
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                // fake the ui
                diceInHand.roll()
            }
        }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.isRolling = false
            
            // update ui
            diceInHand.roll()
            
            // save to core data
            let roll = Roll(context: moc)
            roll.id = UUID()
            roll.diceType = 6
            roll.result = Int16(diceInHand.result)
            roll.rollDate = Date()
            
            try? self.moc.save()
        }
    }
}

struct RollHistoryView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Roll.entity(), sortDescriptors: [NSSortDescriptor(key: "rollDate", ascending: false)]) var rolls: FetchedResults<Roll>
    
    var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(rolls, id: \.id) { roll in
                    HStack {
                        Text("\(formatter.string(from: roll.rollDate!))")
                            .font(.subheadline)
                        Spacer()
                        Label("You rolled a \(roll.result)", systemImage: "die.face.\(roll.result)")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("History")
        }
        
    }
}

struct Dice {
    
    static let possibleValues = [1, 2, 3, 4, 5, 6]
    var result = 5
    
    var displayImage: Image {
        let diceSystemName = "die.face.\(result)"
        return Image(systemName: diceSystemName)
    }
    
    mutating func roll() {
        result = Dice.possibleValues.randomElement()!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
