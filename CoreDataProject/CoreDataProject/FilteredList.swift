//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by David Liongson on 11/4/20.
//

import SwiftUI

struct FilteredList: View {
    
    var fetchRequest: FetchRequest<Singer>
    var singers: FetchedResults<Singer> { fetchRequest.wrappedValue }
    
    var sortDescriptors = [NSSortDescriptor]()
    
    var body: some View {
        List(singers, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
    
    
    init(filter: String) {
        fetchRequest = FetchRequest<Singer>(entity: Singer.entity(), sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter))
    }
    
    init(filter: String, sortDescriptors: [NSSortDescriptor], predicate: FilteredListPredicate) {
        fetchRequest = FetchRequest<Singer>(entity: Singer.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: predicate.rawValue, filter))
    }
    
    enum FilteredListPredicate: String {
        case beginsWith = "lastName BEGINSWITH %@"
        case contains = "lastName CONTAINS %@"
    }
}


