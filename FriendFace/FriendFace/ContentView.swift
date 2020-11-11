//
//  ContentView.swift
//  FriendFace
//
//  Created by David Liongson on 11/5/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var userData = UsersLoader()

    var body: some View {
        NavigationView {
            List {
                ForEach(userData.users, id: \.id) { user in
                    NavigationLink(destination: UserDetailView(user: user, users: userData.users)) {
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
    let user: User
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack {
                
                Text("\(user.friends.count)")
                    .font(.headline)
                Image(systemName: "person.3.fill")
            }
            .foregroundColor(user.friends.count < 5 ? .gray : .blue)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
