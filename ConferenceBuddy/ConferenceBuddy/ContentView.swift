//
//  ContentView.swift
//  ConferenceBuddy
//
//  Created by David Liongson on 12/16/20.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var inputName: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        if let image = image {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        } else {
                            Image(systemName: "questionmark.square.dashed")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.07)
                                .padding([.vertical])
                        }
                        
                        if image != nil {
                            TextField("Enter name", text: self.$inputName)
                                .padding()
                        } else {
                            Text("Use the camera or select a photo from the Photos library")
                                .font(.headline)
                                .padding()
                        }
                        
                        
                    }
                }
                
                AddPhotoView(inputImage: self.$inputImage, image: self.$image)
            }
            .navigationBarTitle("Conference Buddy", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    // show list of attendees
                }, label: {
                    Image(systemName: "person.3")
                }),
                trailing: Button("Save") {
                guard let inputImage = self.inputImage else { return }
                
                let imageSaver = ImageSaver()
                
                imageSaver.successHandler = {
                    print("Success")
                    // add core data write
                                    
                }
                
                imageSaver.errorHandler = {
                    print("Oops: \($0.localizedDescription)")
                }
                
                imageSaver.writeToPhotoAlbum(image: inputImage)
            }
            .disabled(self.image == nil))
        }
    }
}
 
struct AddPhotoView: View {
    
    @State private var showingImagePicker = false
    
    @Binding var inputImage: UIImage?
    @Binding var image: Image?
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                // use image
                self.showingImagePicker = true
            }) {
                Image(systemName: "photo")
                    .padding()
            }
            .background(Color.black.opacity(0.75))
            .foregroundColor(.white)
            .font(.title)
            .clipShape(Circle())
            .padding(.trailing)
            
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func loadImage() {
        if let inputImage = self.inputImage {
            image = Image(uiImage: inputImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
