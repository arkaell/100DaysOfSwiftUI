//
//  ContentView.swift
//  SnowSeekerPro
//
//  Created by David Liongson on 4/4/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var resorts: [Resort] = Bundle.main.decode("resorts.json")
    @State var showOptions: Bool = false
    
    @State var selectedSort: String = "Default"
    @State var selectedSizeFilter: Int = 0
    @State var selectedCountryFilter: String = "None"
    @State var selectedPriceFilter: Int = 0
    
    @ObservedObject var favorites = Favorites()
    
    var body: some View {
        NavigationView {
            List(resorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(trailing:
                                    Button("Options", action: {
                                        self.showOptions = true
                                    })
            )
            
            
            WelcomeView()
        }
        .environmentObject(favorites)
        .sheet(isPresented: $showOptions) {
            ResortListOptionsView(resorts: $resorts,
                                  selectedSort: $selectedSort,
                                  selectedSizeFilter: $selectedSizeFilter,
                                  selectedCountryFilter: $selectedCountryFilter,
                                  selectedPriceFilter: $selectedPriceFilter)
            // Text("Options Here")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
