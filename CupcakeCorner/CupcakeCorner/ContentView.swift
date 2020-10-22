//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by David Liongson on 10/19/20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var orders = Orders()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $orders.item.type) {
                        ForEach(0..<Orders.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper(value: $orders.item.quantity, in: 3...20) {
                        Text("Number of cakes: \(orders.item.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $orders.item.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    
                    if orders.item.specialRequestEnabled {
                        Toggle(isOn: $orders.item.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $orders.item.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(orders: orders)) {
                        Text("Delivery Details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
