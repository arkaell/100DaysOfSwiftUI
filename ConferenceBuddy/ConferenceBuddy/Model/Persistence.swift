//
//  Persistence.swift
//  ConferenceBuddy
//
//  Created by David Liongson on 12/16/20.
//

import CoreData

class PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BuddiesModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    static var preview: PersistenceController = {

        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let buddy1 = Buddy(context: viewContext)
        buddy1.id = UUID()
        buddy1.name = "Tom Brady"
        
        let buddy2 = Buddy(context: viewContext)
        buddy2.id = UUID()
        buddy2.name = "Tedy Bruschi"
        
        let buddy3 = Buddy(context: viewContext)
        buddy3.id = UUID()
        buddy3.name = "Bill Belichick"
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
}
