//
//  Models.swift
//  FriendFace
//
//  Created by David Liongson on 11/10/20.
//

import Foundation

class UsersLoader: ObservableObject {
    @Published var users = [User]()
    
    init() {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
//        var request = URLRequest(url: url)

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            //2015-11-10T01:47:18-00:00
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            if let decodedData = try? decoder.decode([User].self, from: data) {
                DispatchQueue.main.async {
                    self.users = decodedData
                }
                
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }

}

struct User: Codable {
        
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
}

struct Friend: Codable {
    var id: String
    var name: String
}
