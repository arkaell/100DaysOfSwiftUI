//
//  AddBuddyView.swift
//  ConferenceBuddy
//
//  Created by David Liongson on 12/16/20.
//

import SwiftUI

struct AddBuddyView: View {
        
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var image: Image = Image(systemName: "person.fill.viewfinder")
    @State private var inputImage: UIImage?
    @State private var name: String = ""
    @State private var position: String = ""
    @State private var showingImagePicker = false
        
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .foregroundColor(.patsNavy)
                            .opacity( inputImage != nil ? 1.0 : 0.15)
                            .onTapGesture {
                                self.showingImagePicker = true
                            }

                        if inputImage != nil {
                            TextField("Enter player name", text: self.$name)
                                .padding()
                            TextField("Enter position", text: self.$position)
                                .padding()
                        } else {
                            Text("Tap to select a photo from the Photos library")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .foregroundColor(Color.patsNavy)
                        }
                    }
                }
                
            }
            .navigationBarTitle("Pats Buddy", displayMode: .inline)
            .navigationBarItems(
                trailing: SaveButton(inputImage: self.$inputImage, name: self.$name, position: self.$position, dismissAction: dismissView)
                    .environment(\.managedObjectContext, moc))
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
    }
    
    func dismissView() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func loadImage() {
        if let inputImage = self.inputImage {
            image = Image(uiImage: inputImage)
        }
    }
}


struct SaveButton: View {
    
    @Binding var inputImage: UIImage?
    @Binding var name: String
    @Binding var position: String

    let dismissAction: () -> Void
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        Button(action: {
            guard let inputImage = self.inputImage else { return }
            
            let buddy = Buddy(context: moc)
            buddy.id = UUID()
            buddy.name = self.name
            buddy.position = self.position
            buddy.photoID = UUID()
            
            if moc.hasChanges {
                do {
                    try moc.save()
                    saveData(inputImage: inputImage, id: buddy.photoID!)
                    
                } catch(let error as NSError) {
                    fatalError("Error saving context: \(error), \(error.userInfo)")
                }
            }
            
            dismissAction()
            
        }, label: {
            Text("Save")
                .foregroundColor(inputImage == nil || name.isEmpty ? .gray : .patsNavy)
        })
        .disabled(inputImage == nil)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func saveData(inputImage: UIImage, id: UUID) {
        
        if let jpegData = inputImage.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(id.uuidString)
            try? jpegData.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("save data OK")
        }
    }
    
}

struct CameraButton: View {
    
    var body: some View {
        Button(action: {
            // 
            
        }) {
            Image(systemName: "camera")
                .padding()
        }
        .background(Color.patsNavy.opacity(0.90))
        .foregroundColor(.white)
        .font(.title)
        .clipShape(Circle())
        .padding(.trailing)
    }
}

struct PhotosButton: View {
    
    @Binding var showingImagePicker: Bool
    
    var body: some View {
        Button(action: {
            // use image
            self.showingImagePicker = true
        }) {
            Image(systemName: "photo")
                .padding()
        }
        .background(Color.patsNavy.opacity(0.90))
        .foregroundColor(.white)
        .font(.title)
        .clipShape(Circle())
        .padding(.trailing)
    }
}

struct AddBuddyView_Previews: PreviewProvider {
    static var previews: some View {
        AddBuddyView()
    }
}
