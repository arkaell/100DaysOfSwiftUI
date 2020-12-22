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
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var name: String = ""
    @State private var position: String = ""
    @State private var number: String = ""
    
    @State private var showSuccessAlert = false
        
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        if let image = image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        } else {
                            Image(systemName: "questionmark.square.dashed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .opacity(0.07)
                                .padding([.vertical])
                        }
                        
                        if image != nil {
                            TextField("Enter player name", text: self.$name)
                                .padding()
                            TextField("Enter position", text: self.$position)
                                .padding()
                            TextField("Enter number", text: self.$number)
                                .padding()
                        } else {
                            Text("Use the camera or select a photo from the Photos library")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .foregroundColor(Color.patsNavy)
                        }
                    }
                }
                
                AddPhotoView(inputImage: self.$inputImage, image: self.$image)
            }
            .navigationBarTitle("Pats Buddy", displayMode: .inline)
            .navigationBarItems(
                trailing: SaveButton(inputImage: self.$inputImage, name: self.$name, position: self.$position, number: self.$number, dismissAction: dismissView)
                    .environment(\.managedObjectContext, moc))
        }
    }
    
    func dismissView() {
        self.presentationMode.wrappedValue.dismiss()
    }
}


struct SaveButton: View {
    
    @Binding var inputImage: UIImage?
    @Binding var name: String
    @Binding var position: String
    @Binding var number: String

    let dismissAction: () -> Void
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        Button(action: {
            guard let inputImage = self.inputImage else { return }
            
            let buddy = Buddy(context: moc)
            buddy.id = UUID()
            buddy.name = self.name
            buddy.position = self.position
            buddy.number = Int16(self.number) ?? 0
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
 
struct AddPhotoView: View {
    
    @State private var showingImagePicker = false
    
    @Binding var inputImage: UIImage?
    @Binding var image: Image?
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                CameraButton()
                PhotosButton(showingImagePicker: self.$showingImagePicker)
            }
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
