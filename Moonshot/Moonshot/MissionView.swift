//
//  MissionView.swift
//  Moonshot
//
//  Created by David Liongson on 10/2/20.
//

import SwiftUI

struct MissionView: View {
    let mission: Mission
    
    let astronauts: [CrewMember]
    
    let missions: [Mission]
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { geo in
                        Image(self.mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: geometry.size.width)
                            .scaleEffect(calculateScale(geo, geometry))
                            .accessibility(label: Text("\(mission.displayName)"))
                    }
                    .layoutPriority(1)
                    
                    Text("Launch date: \(self.mission.formattedLaunchDate)")
                                        
                    Text(self.mission.description)
                        .padding()
                        .layoutPriority(1)
                    
                    ForEach(astronauts, id:\.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut, missions: missions)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                    .accessibility(label: Text("\(crewMember.astronaut.name)"))
                                    .accessibility(hint: Text("Press to view \(crewMember.astronaut.name)'s profile"))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                .accessibilityElement(children: .ignore)
                                .accessibility(label: Text("\(crewMember.astronaut.name) is a \(crewMember.role)"))
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
        }
        
    }
    
    private func calculateScale(_ geo: GeometryProxy, _ geometry: GeometryProxy) -> CGFloat {
        var offset: CGFloat = 0.0
        let geoHeight = geometry.size.height
        let imgMaxY = geo.frame(in: .global).maxY
        
        let diff = geoHeight - imgMaxY
        offset = diff / (geoHeight / 0.5)
        print("geoHeight: \(geoHeight), imgMaxY: \(imgMaxY), diff: \(diff), offset: \(offset)")
        
        return 1.0 - offset
    }
    
    init(mission: Mission, astronauts: [Astronaut], missions: [Mission]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing member.")
            }
        }
        
        self.astronauts = matches
        self.missions = missions
        
    }
}

struct MissionView_Previews: PreviewProvider {
    
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts, missions: missions)
    }
}
