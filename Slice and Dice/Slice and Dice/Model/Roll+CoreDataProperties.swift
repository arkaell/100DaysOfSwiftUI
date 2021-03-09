//
//  Roll+CoreDataProperties.swift
//  Slice and Dice
//
//  Created by David Liongson on 3/7/21.
//
//

import Foundation
import CoreData


extension Roll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Roll> {
        return NSFetchRequest<Roll>(entityName: "Roll")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var rollDate: Date?
    @NSManaged public var diceType: Int16
    @NSManaged public var result: Int16

}

extension Roll : Identifiable {

}
