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
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 300, minHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                
//                testImage
//                    .resizable()
//                    .scaledToFit()
//                    .frame(minWidth: 300, minHeight: 300)
//                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                
                VStack {
                    Text(buddy.name ?? "Unknown Player")
                        .font(.largeTitle)
                        .fontWeight(.semibold)

                    Text(buddy.position ?? "Player")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding(8)
                .background(Color.patsNavy.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .offset(x: -10.0, y: -10.0)
            }
            .frame(minWidth: 300, minHeight: 300)
            .padding()
            Spacer()
        }
       
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
