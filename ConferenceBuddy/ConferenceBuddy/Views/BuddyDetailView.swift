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
            ZStack(alignment: .bottom) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(alignment: .topLeading)
                    .ignoresSafeArea(.keyboard, edges: [.bottom, .horizontal])
                    .offset(x: 0, y: 25.0)
                
                Text(buddy.name ?? "Buddy")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.patsNavy.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
            
            Text("Map View Goes Here")
            
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
