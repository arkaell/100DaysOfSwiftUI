//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by David Liongson on 11/5/20.
//

import SwiftUI
import CoreData


@main
struct FriendFaceApp: App {

    let persistenceController = PersistenceController.shared
        
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    fileprivate func loadUsers() {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            if let decodedData = try? decoder.decode([User].self, from: data) {
                
                //                DispatchQueue.main.async {
                //                    self.users = decodedData
                //                }
                for user in decodedData {
//                    print("Attempting to create UserModel")
                    let newUserModel = UserModel(context: self.persistenceController.container.viewContext)
                    newUserModel.id = UUID(uuidString: user.id)
                    newUserModel.isActive = user.isActive
                    newUserModel.name = user.name
                    newUserModel.age = Int16(user.age)
                    newUserModel.email = user.email
                    newUserModel.address = user.address
                    newUserModel.registered = user.registered
                    newUserModel.company = user.company
                    
                    var friendSet = [FriendModel]()
                    for friend in user.friends {
                        let newFriend = FriendModel(context: self.persistenceController.container.viewContext)
                        newFriend.id = UUID(uuidString: friend.id)
                        newFriend.name = friend.name
                        friendSet.append(newFriend)
                    }
                    
                    newUserModel.friends = NSSet(array: friendSet)


                    if self.persistenceController.container.viewContext.hasChanges {
//                        print("Attempting to save")
                        try? self.persistenceController.container.viewContext.save()
                    }
                }
                
                
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
    
    init() {
        print("Fetching data to populate Core Data")
        loadUsers()
    }
}
