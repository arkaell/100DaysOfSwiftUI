//
//  SettingsView.swift
//  FlashZilla
//
//  Created by David Liongson on 2/6/21.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var retryMistakes: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $retryMistakes) {
                    Text("Retry your mistakes")
                }
                .padding()
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                self.dismiss()
            })
        }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(retryMistakes: .constant(false))
    }
}
