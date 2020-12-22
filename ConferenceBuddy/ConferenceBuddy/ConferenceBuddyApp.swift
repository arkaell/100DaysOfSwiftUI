//
//  ConferenceBuddyApp.swift
//  ConferenceBuddy
//
//  Created by David Liongson on 12/16/20.
//

import SwiftUI

@main
struct ConferenceBuddyApp: App {
    
    let persistence = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            BuddyListView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
