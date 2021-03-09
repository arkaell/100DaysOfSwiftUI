//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by David Liongson on 10/20/20.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var orders: Orders
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                        .accessibilityHidden(true)
                    
                    Text("Your total is $\(self.orders.item.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        // place the order
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text(alertMessage), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(orders.item) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
//            print(error?.localizedDescription ?? "Unkown Error")
            
            guard let data = data, error == nil else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                
                self.confirmationMessage = error?.localizedDescription ?? "Unknown error"
                self.alertMessage = "Error"
                self.showingConfirmation = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(OrderItem.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.alertMessage = "Thank You!"
                self.showingConfirmation = true
                
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(orders: Orders())
    }
}
