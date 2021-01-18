//
//  AddBuddyView.swift
//  ConferenceBuddy
//
//  Created by David Liongson on 12/16/20.
//

import SwiftUI
import CoreLocation

struct AddBuddyView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var image: Image = Image(systemName: "person.fill.viewfinder")
    @State private var inputImage: UIImage?
    @State private var name: String = ""

    @State private var showingImagePicker = false
    @State private var isLocationFetcherStarted = false
    @State private var coordinate: CLLocationCoordinate2D?
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center) {
                
                BuddyPhotoView(image: $image, inputImage: $inputImage)
                    .onTapGesture {
                        self.showingImagePicker = true
                    }
                
                HStack {
                    Label("Name", systemImage: "person")
                    TextField("Patriots player", text: self.$name)
                        .foregroundColor(.patsNavy)
                }
                .padding()
                
                Button("Click to start saving location") {
                    if let newCoordinate = self.locationFetcher.lastKnownLocation {
                        self.coordinate = newCoordinate
                        print("location is \(self.coordinate!)")
                    } else {
                        print("location is unknown")
                    }
                }
                .padding()
                .background(Color.patsNavy)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .font(.headline)
                .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Conference Buddy", displayMode: .inline)
            .navigationBarItems(
                trailing: SaveButton(inputImage: self.$inputImage, name: self.$name, coordinate: self.coordinate, dismissAction: dismissView)
                    .environment(\.managedObjectContext, moc))
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        
    }
    
    init() {
        self.locationFetcher.start()

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
    var coordinate: CLLocationCoordinate2D?

    let dismissAction: () -> Void
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        Button(action: {
            guard let inputImage = self.inputImage else { return }
            
            let buddy = Buddy(context: moc)
            buddy.id = UUID()
            buddy.name = self.name
            buddy.photoID = UUID()
            buddy.locationID = nil
            print("Saving Coordinate \(coordinate)")
            if coordinate != nil {
                buddy.locationID = UUID()
            }
            
            if moc.hasChanges {
                do {
                    try moc.save()
                    saveData(inputImage: inputImage, id: buddy.photoID!)
                    if let coordinate = coordinate {
                        saveLocation(coordinate: coordinate, id: buddy.locationID!)
                    }
                    
                    
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
    
    private func saveLocation(coordinate: CLLocationCoordinate2D, id: UUID) {
        do {
            let newLocation = CodableMKPointAnnotation()
            newLocation.coordinate = coordinate
            let filename = getDocumentsDirectory().appendingPathComponent(id.uuidString)
            let data = try JSONEncoder().encode(newLocation)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("save location OK")
        } catch {
            print("unable to save location")
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

struct BuddyPhotoView: View {
    
    @Binding var image: Image
    @Binding var inputImage: UIImage?
    
    var body: some View {
        ZStack(alignment: .center) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 300, minHeight: 300, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .foregroundColor(.patsNavy)
                .opacity(inputImage != nil ? 1.0 : 0.055)
                .padding()
            
            
            if(inputImage == nil) {
                Text("Tap to select a photo from the Photos library")
                    .frame(width: 200, height: 200, alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundColor(Color.patsNavy)
            }
        }
    }
}
