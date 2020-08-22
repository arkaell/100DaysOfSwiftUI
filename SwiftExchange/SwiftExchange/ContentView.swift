//
//  ContentView.swift
//  SwiftExchange
//
//  Created by David Liongson on 8/22/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var inputAmount: String = "1.0"
    @State var inputCurrency: Int = 0
    @State var outputCurrency: Int = 1
    
    private let currencies = ["USD", "PHP", "AUD", "SGD"]
    private let exchangeRates = [1.0, 48.66, 1.4, 1.37]
    
    var baseUnitAmount: Double {
        let originalAmount = (Double(inputAmount) ?? 1.0)
        let baseUnitAmount = originalAmount / exchangeRates[inputCurrency]
        return baseUnitAmount
    }
    
    var convertedAmount: Double {
        return baseUnitAmount * exchangeRates[outputCurrency]
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("From:")) {
                    Picker("From", selection: $inputCurrency) {
                        ForEach(0..<currencies.count) {
                            Text("\(self.currencies[$0])")
                        }
                    }
                }
                    .pickerStyle(SegmentedPickerStyle())
                Section(header: Text("To:")) {
                    Picker("To", selection: $outputCurrency) {
                        ForEach(0..<currencies.count) {
                            Text("\(self.currencies[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Amount in \(currencies[inputCurrency]):")) {
                    TextField("Enter amount to convert", text: $inputAmount)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Amount in \(currencies[outputCurrency]):")) {
                    Text("\(convertedAmount, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("Swift Exchange")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
