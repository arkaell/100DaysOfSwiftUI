//
//  UserDetailView.swift
//  FriendFace
//
//  Created by David Liongson on 11/10/20.
//

import SwiftUI

struct UserDetailView: View {
    
    var user: User
    var users: [User]
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Spacer()
                Text("Registered on \(formatter.string(from: user.registered))")
                    .font(.caption)
                    
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.blue)
                Text(": \(user.email)")
                    .foregroundColor(.blue)
                    .font(.callout)
            }
            .padding([.bottom, .horizontal])
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text(": \(user.age) years old")
                    .font(.callout)
            }
            .padding([.bottom, .horizontal])
            
            
            
            HStack {
                Image(systemName: "house")
                    .foregroundColor(.blue)
                Text(": \(user.address)")
                    .font(.callout)

            }
            .padding([.bottom, .horizontal])
                        
            HStack {
                Image(systemName: "person.3.fill")
                    .foregroundColor(.blue)
                
                Text("\(user.friends.count)")
            }
            .padding([.bottom, .horizontal])
            
            List {
                ForEach(user.friends, id: \.id) { friend in
                    NavigationLink(destination: UserDetailView(user: getUser(for: friend), users: users)) {
                        Text(friend.name)
                            .font(.callout)
                            .foregroundColor(.blue)
                    }
                }
            }
            Spacer()
        }
        .navigationBarTitle(user.name)
        
    }
    
    var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    private func getUser(for friend: Friend) -> User {
        return users.first(where: { $0.id == friend.id })!
    }
}

