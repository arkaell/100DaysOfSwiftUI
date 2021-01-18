//
//  Buddy+CoreDataProperties.swift
//  ConferenceBuddy
//
//  Created by David Liongson on 1/18/21.
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
    @NSManaged public var locationID: UUID?

}

extension Buddy : Identifiable {

}
