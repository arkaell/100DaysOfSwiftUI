//
//  UserDetailView.swift
//  FriendFace
//
//  Created by David Liongson on 11/10/20.
//

import SwiftUI

struct UserDetailView: View {
    
    var user: UserModel
    var users: [UserModel]
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Spacer()
                Text("Registered on \(formatter.string(from: user.wrappedRegistered))")
                    .font(.caption)
                    
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.blue)
                Text(": \(user.wrappedEmail)")
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
                Text(": \(user.wrappedAddress)")
                    .font(.callout)

            }
            .padding([.bottom, .horizontal])
                        
            HStack {
                Image(systemName: "person.3.fill")
                    .foregroundColor(.blue)
                
                Text("\(user.friendsArray.count)")
            }
            .padding([.bottom, .horizontal])
            
            List {
                ForEach(user.friendsArray, id: \.self) { friend in
                    NavigationLink(destination: UserDetailView(user: getUser(for: friend), users: users)) {
                        Text("\(friend.wrappedName)")
                            .foregroundColor(.blue)
                            .font(.callout)
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarTitle(user.wrappedName)
        
    }
    
    var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    private func getUser(for friend: FriendModel) -> UserModel {
        return users.first(where: { $0.id == friend.id })!
    }
}

