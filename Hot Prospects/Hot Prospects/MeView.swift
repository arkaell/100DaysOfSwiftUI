//
//  MeView.swift
//  Hot Prospects
//
//  Created by David Liongson on 1/22/21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    static let saveKey = "MyData"

    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                    .padding(.horizontal)
                
                TextField("Email Address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                    .padding([.horizontal, .bottom])
                
                Button("Save") {
                    save()
                }
                    .padding()
                    .foregroundColor(.white)
                    .font(.title)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding([.bottom])
                    
                
                Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    
                
                Spacer()
            }
            .navigationBarTitle("Your code")
            
        }
        .onAppear(perform: load)
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    private func save() {
        let me = Prospect()
        me.name = self.name
        me.emailAddress = self.emailAddress
        
        if let encoded = try? JSONEncoder().encode(me) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode(Prospect.self, from: data) {
                self.name = decoded.name
                self.emailAddress = decoded.emailAddress
                return
            }
        }
        
        self.name = "Anonymous"
        self.emailAddress = "you@yoursite.com"
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MeView()
        }
    }
}

struct SaveMeButtonView: View {
    
    var name: String
    var emailAddress: String
    
    
    var body: some View {
        Button("Save") {
            print("Saving")
        }
    }
    
    
}
