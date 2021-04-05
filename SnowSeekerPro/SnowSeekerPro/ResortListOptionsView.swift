//
//  ResortListOptionsView.swift
//  SnowSeekerPro
//
//  Created by David Liongson on 4/4/21.
//

import SwiftUI

struct ResortListOptionsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var resorts: [Resort]
    
    @Binding var selectedSort: String
    @Binding var selectedSizeFilter: Int
    @Binding var selectedCountryFilter: String
    @Binding var selectedPriceFilter: Int
    
    let sortOptions = ["Default", "Alphabetical", "Country"]
    let filterBySizeOptions = [0, 1, 2, 3]
    let filterByCountryOptions = ["None", "Austria", "Canada", "France", "Italy", "United States"]
    let filterByPriceOptions = [0, 1, 2, 3]
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Choose a sort option", selection: $selectedSort) {
                    ForEach(sortOptions, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Choose a facility size", selection: $selectedSizeFilter) {
                    ForEach(filterBySizeOptions, id: \.self) {
                        Text(size($0))
                    }
                }

                Picker("Choose a country", selection: $selectedCountryFilter) {
                    ForEach(filterByCountryOptions, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Choose a price", selection: $selectedPriceFilter) {
                    ForEach(filterByPriceOptions, id: \.self) {
                        Text(price($0))
                    }
                }
            }
            .navigationBarTitle(Text("Options"))
            .navigationBarItems(trailing: Button("Done", action: {
                
                reload()
                
                if selectedSizeFilter != 0 { filterBySize() }
                if selectedCountryFilter != "None" { filterByCountry() }
                if selectedPriceFilter != 0 { filterByPrice() }
                
                sort()
                
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    private func sort() {
        if selectedSort == "Alphabetical" {
            resorts.sort { $0.name < $1.name }
        } else if selectedSort == "Country" {
            resorts.sort { $0.country < $1.country }
        }
    }
    
    private func reload() {
        resorts = Bundle.main.decode("resorts.json")
    }
    
    private func filterByCountry() {
        let filteredResorts = resorts.filter { $0.country == selectedCountryFilter }
        resorts = filteredResorts
    }
    
    private func filterBySize() {
        let filteredResorts = resorts.filter { $0.size == selectedSizeFilter }
        resorts = filteredResorts
    }
    
    private func filterByPrice() {
        let filteredResorts = resorts.filter { $0.price == selectedPriceFilter }
        resorts = filteredResorts
    }
    
    private func size(_ selectedSize: Int) -> String {
        switch selectedSize {
        case 1:
            return "Small"
        case 2:
            return "Average"
        case 3:
            return "Large"
        default:
            return "None"
        }
    }
    
    private func price(_ selectedPrice: Int) -> String {
        switch selectedPrice {
        case 0:
            return "None"
        default:
            return String(repeating: "$", count: selectedPrice)
        }
    }
}

//struct ResortListOptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResortListOptionsView(resorts: .constant(Resort.allResorts))
//    }
//}
