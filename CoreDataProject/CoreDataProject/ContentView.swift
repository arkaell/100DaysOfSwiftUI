//
//  ContentView.swift
//  CoreDataProject
//
//  Created by David Liongson on 11/2/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "Swift"
    
    private let sortDescriptors = [
        NSSortDescriptor(key: "lastName", ascending: true),
        NSSortDescriptor(key: "firstName", ascending: true)
    ]

    var body: some View {
        VStack {
            
            FilteredList(filter: lastNameFilter, sortDescriptors: sortDescriptors, predicate: .contains)
            
            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                
                let ed = Singer(context: self.moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                
                let adele = Singer(context: self.moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                try? self.moc.save()
            }
            
            Button("Show Ed") {
                self.lastNameFilter = "Sheer"
            }
            
            Button("Show Adele") {
                self.lastNameFilter = "Adkin"
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
