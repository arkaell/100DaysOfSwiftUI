//
//  BuddyDetailView.swift
//  ConferenceBuddy
//
//  Created by David Liongson on 12/23/20.
//

import SwiftUI
import CoreData

struct BuddyDetailView: View {
    
    var buddy: Buddy
//    var testImage: Image
    
    private var uiImage: UIImage {
        let filename = getDocumentsDirectory().appendingPathComponent(buddy.photoID!.uuidString)
        return UIImage(contentsOfFile: filename.path)!
    }
    
    private var annotation: CodableMKPointAnnotation? {
        
        if let id = buddy.locationID {
            print("loading location")
            let filename = getDocumentsDirectory().appendingPathComponent(id.uuidString)
            do {
                let data = try Data(contentsOf: filename)
                let decodedAnnotation = try JSONDecoder().decode(CodableMKPointAnnotation.self, from: data)
                print("\(decodedAnnotation.coordinate)")
                return decodedAnnotation
            } catch {
                print("Cannot load location")
                return nil
            }
            
        } else {
            print("no location")

            return nil
        }
    }
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.bottom)
            .overlay(
                VStack() {
                    Text(buddy.name ?? "Player")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.patsNavy.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    if annotation != nil {
                        MapView(centerCoordinate: annotation!.coordinate, annotations: [annotation!])
                            .frame(width: 300, height: 180, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding()
                    }
                }
                .padding(),
                alignment: .bottom
            )
            
//
            
            
            

            
       
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//struct BuddyDetailView_Previews: PreviewProvider {
//    
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//    
//    static var previews: some View {
//        let buddy = Buddy(context: moc)
//        buddy.name = "Tom Brady"
//        buddy.position = "Quarterback"
//        buddy.id = UUID()
//        buddy.photoID = UUID()
//        
//        
//        
//        return NavigationView {
//            BuddyDetailView(buddy: buddy, testImage: Image("tombrady"))
//        }
//    }
//}
