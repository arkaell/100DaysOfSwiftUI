//
//  Book_WormApp.swift
//  Book Worm
//
//  Created by David Liongson on 10/25/20.
//

import SwiftUI

@main
struct Book_WormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
