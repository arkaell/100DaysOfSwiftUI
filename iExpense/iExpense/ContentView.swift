//
//  ContentView.swift
//  iExpense
//
//  Created by David Liongson on 9/26/20.
//

import SwiftUI

struct ContentView: View {
        
    @ObservedObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text("$\(item.amount)")
                            .foregroundColor(item.amount >= 1_000 ? .red : .green)
                    }
                    
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing:
                                    Button(action: {
                                        showingAddExpense.toggle()
                                    }) {
                                        Image(systemName: "plus")
                                    }
            )

            .sheet(isPresented: $showingAddExpense, content: {
                // show an AddView here
                AddView(expenses: expenses)
            })
        }
    }
    
    
    // removing items
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
