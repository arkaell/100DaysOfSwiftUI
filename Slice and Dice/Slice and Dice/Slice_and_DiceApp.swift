//
//  Slice_and_DiceApp.swift
//  Slice and Dice
//
//  Created by David Liongson on 2/22/21.
//

import SwiftUI

@main
struct Slice_and_DiceApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
