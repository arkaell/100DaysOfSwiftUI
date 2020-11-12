//
//  ContentView.swift
//  FriendFace
//
//  Created by David Liongson on 11/5/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
        
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: UserModel.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var users: FetchedResults<UserModel>

    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.self) { user in
                    NavigationLink(destination: UserDetailView(user: user, users: users.sorted(by: { $0.wrappedName < $1.wrappedName }))) {
                        UserRowView(user: user)
                    }
                }
                .padding()
            }
            .navigationTitle("FriendFace")
        }
    }
    


}

struct UserRowView: View {
    let user: UserModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.wrappedName)
                    .font(.headline)
                Text(user.wrappedEmail)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack {
                
                Text("\(user.friendsArray.count)")
                    .font(.headline)
                Image(systemName: "person.3.fill")
            }
            .foregroundColor(user.friendsArray.count < 5 ? .gray : .blue)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
