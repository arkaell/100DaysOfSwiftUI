//
//  Buddy+CoreDataProperties.swift
//  ConferenceBuddy
//
//  Created by David Liongson on 12/20/20.
//
//

import Foundation
import CoreData


extension Buddy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Buddy> {
        return NSFetchRequest<Buddy>(entityName: "Buddy")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var photoID: UUID?
    @NSManaged public var position: String?
    @NSManaged public var number: Int16

}

extension Buddy : Identifiable {

}
