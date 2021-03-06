//
//  ContentView.swift
//  Book Worm
//
//  Created by David Liongson on 10/25/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(entity: Book.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Book.title, ascending: true),
                    NSSortDescriptor(keyPath: \Book.author, ascending: true)
                  ])
    var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        VStack(alignment: .leading) {
                            Text(self.formatDate(book.date))
                                .font(.caption2)
                                .padding(2)
                            
                            HStack {
                                EmojiRatingView(rating: book.rating)
                                    .font(.largeTitle)
                                
                                VStack(alignment: .leading) {
                                    Text(book.title ?? "Unknown Title")
                                        .font(.headline)
                                        .foregroundColor(book.rating == 1 ? .red : .black)
                                    Text(book.author ?? "Unknown Author")
                                        .foregroundColor(.secondary)

                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationBarTitle("Book Worm")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddScreen.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddScreen) {
                AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            
            moc.delete(book)
        }
        
        try? moc.save()
    }
    
    func formatDate(_ date: Date?) -> String {
        
        var output = ""
        
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            output = formatter.string(from: date)
        }
        
        return output
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
