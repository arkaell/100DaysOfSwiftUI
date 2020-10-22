//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by David Liongson on 10/20/20.
//

import SwiftUI

struct AddressView: View {
    
    @ObservedObject var orders: Orders
    
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $orders.item.name)
                TextField("Street Address", text: $orders.item.streetAddress)
                TextField("City", text: $orders.item.city)
                TextField("Zip", text: $orders.item.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(orders: orders)) {
                    Text("Check out")
                }
            }
            .disabled(orders.item.hadValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(orders: Orders())
    }
}
