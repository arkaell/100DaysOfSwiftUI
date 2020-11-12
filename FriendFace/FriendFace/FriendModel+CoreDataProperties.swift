//
//  FriendModel+CoreDataProperties.swift
//  FriendFace
//
//  Created by David Liongson on 11/12/20.
//
//

import Foundation
import CoreData


extension FriendModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendModel> {
        return NSFetchRequest<FriendModel>(entityName: "FriendModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var user: UserModel?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
}

extension FriendModel : Identifiable {

}
