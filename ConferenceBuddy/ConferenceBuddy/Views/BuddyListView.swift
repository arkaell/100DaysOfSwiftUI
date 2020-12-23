//
//  BuddyListView.swift
//  ConferenceBuddy
//
//  Created by David Liongson on 12/20/20.
//

import SwiftUI
import CoreData

struct BuddyListView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Buddy.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Buddy.name, ascending: true)]) var buddies: FetchedResults<Buddy>
    
    @State private var showingAddBuddy = false
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(buddies, id: \.self) { buddy in
                    NavigationLink(destination: BuddyDetailView(buddy: buddy)) {
                        HStack {
                            ImageThumbNailView(photoID: buddy.photoID)
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                
                            VStack {
                                HStack {
                                    Text(buddy.name ?? "New England Patriot")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                    
                                HStack {
                                    Text("\(buddy.position ?? "Player") ")
                                        .font(.caption)
                                    Spacer()
                                }
                            }
                            .foregroundColor(.patsNavy)
                        }
                    }
                }
            }
            .navigationBarTitle("Pats Buddy", displayMode: .inline)
            .navigationBarItems(trailing: AddBuddyButton(showingAddBuddy: self.$showingAddBuddy))
            .sheet(isPresented: $showingAddBuddy, onDismiss: saveData) {
                AddBuddyView().environment(\.managedObjectContext, moc)
            }

        }
    }
    
    private func saveData() {
        print("Saving Data")
    }
    
    
}

struct ImageThumbNailView: View {
    
    var photoID: UUID?
    
    private var uiImage: UIImage {
        let filename = getDocumentsDirectory().appendingPathComponent(photoID!.uuidString)
        return UIImage(contentsOfFile: filename.path)!
    }
    
    var body: some View {
        if photoID != nil {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "questionmark.square.dashed")
                .resizable()
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct AddBuddyButton: View {
    
    @Binding var showingAddBuddy: Bool
    
    var body: some View {
        Button(action: {
            self.showingAddBuddy = true
        }) {
            Image(systemName: "person.badge.plus")
                .foregroundColor(.patsNavy)
        }
    }
    
    
}

struct BuddyListView_Previews: PreviewProvider {
    static var previews: some View {
        BuddyListView()
    }
}
