//
//  ContentView.swift
//  Moonshot
//
//  Created by David Liongson on 9/30/20.
//

import SwiftUI

struct ContentView: View {
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State var toggleDefaultDisplayToCrew = false
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: astronauts, missions: missions)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(toggleDefaultDisplayToCrew ? mission.crewSummary : mission.formattedLaunchDate)
                            .font(.caption)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibility(label: Text("\(mission.displayName), \(toggleDefaultDisplayToCrew ? mission.crewSummary : mission.formattedLaunchDate)"))
                .accessibility(hint: Text("Tap to view the \(mission.displayName) mission details"))
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing: Button("Toggle") {
                self.toggleDefaultDisplayToCrew.toggle()
            }
            .accessibility(label: Text("Toggle list to show summary or launch date"))
            )
        }
    }
}

struct User: Codable {
    var name: String
    var address: Address
}

struct Address: Codable {
    var street: String
    var city: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
