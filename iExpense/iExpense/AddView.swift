//
//  AddView.swift
//  iExpense
//
//  Created by David Liongson on 9/27/20.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @State private var showInvalidAmountAlert = false
    
    static let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:
                                    Button("Save") {
                                        if let actualAmount = Int(self.amount) {
                                            let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                                            self.expenses.items.append(item)
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else {
                                            showInvalidAmountAlert.toggle()
                                        }
                                    }
            )
        }
        .alert(isPresented: $showInvalidAmountAlert) { () -> Alert in
            Alert(title: Text("Invalid Expense Amount"), message: Text("Please enter a valid amount"), dismissButton: .default(Text("Ok")))
        }
        
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
