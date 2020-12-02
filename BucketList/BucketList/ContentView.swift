//
//  ContentView.swift
//  BucketList
//
//  Created by David Liongson on 11/26/20.
//

import LocalAuthentication
import MapKit
import SwiftUI

struct ContentView: View {
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    
    @State private var isUnlocked = false
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    @State private var showingAuthErrorAlert = false
    @State private var authenticationError = ""
    

    var body: some View {
        ZStack {
            if isUnlocked {
                MapView(centerCoordinate: $centerCoordinate,
                        selectedPlace: $selectedPlace,
                        showingPlaceDetails: $showingPlaceDetails,
                        annotations: locations)
                    .edgesIgnoringSafeArea(.all)
                
                CircleTargetView()
                
                AddLocationButton(locations: $locations,
                                  centerCoordinate: $centerCoordinate,
                                  selectedPlace: $selectedPlace,
                                  showingEditScreen: $showingEditScreen)
            } else {
                AuthenticateButton(showAuthErrorAlert: $showingPlaceDetails, authenticationError: $authenticationError, isUnlocked: $isUnlocked)
            }
        }
        .alert(isPresented: $showingPlaceDetails) {
            
            var alert = Alert(title: Text("Placeholder"))
            
            if isUnlocked {
                alert = Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                    self.showingEditScreen = true
                })
            } else {
                alert = Alert(title: Text("Authentication Error"), message: Text("\(authenticationError)"), dismissButton: .default(Text("OK")))
            }
            
            return alert
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditView(placemark: self.selectedPlace!)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")

        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }

    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("save data OK")
        } catch {
            print("Unable to save data.")
        }
    }
    
    

}

struct AuthenticateButton: View {
    
    @Binding var showAuthErrorAlert: Bool
    @Binding var authenticationError: String
    @Binding var isUnlocked: Bool
        
    var body: some View {
        Button("Unlock Places") {
            self.authenticate()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())

    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        // error
                        self.authenticationError = authenticationError?.localizedDescription ?? "Unknown error description"
                        self.showAuthErrorAlert = true
                    }
                }
            }
        } else {
            // no biometrics
            self.authenticationError = error?.localizedDescription ?? "No Touch ID or Face ID available"
            self.showAuthErrorAlert = true
        }
    }
}

struct CircleTargetView: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)
    }
}

struct AddLocationButton: View {
    
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingEditScreen: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    let newLocation = CodableMKPointAnnotation()
                    newLocation.title = "Example location"
                    newLocation.coordinate = self.centerCoordinate
                    self.locations.append(newLocation)
                    self.selectedPlace = newLocation
                    self.showingEditScreen = true
                }) {
                    Image(systemName: "plus")
                        .padding()
                }
                .background(Color.black.opacity(0.75))
                .foregroundColor(.white)
                .font(.title)
                .clipShape(Circle())
                .padding(.trailing)
            }
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
