//
//  ContentView.swift
//  Hot Prospects
//
//  Created by David Liongson on 1/19/21.
//

import SwiftUI

struct ContentView: View {
    
    let user = User()
    
    @State private var selectedTab = "first"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1")
                .onTapGesture {
                    self.selectedTab = "second"
                }
                .tabItem {
                    Image(systemName: "star")
                    Text("One")
                }
                .tag("first")
            
            Text("Tab 2")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Two")
                }
                .tag("second")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

struct EditView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        TextField("Name", text: $user.name)
    }
}

struct DisplayView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        Text(user.name)
    }
}
