//
//  UserModel+CoreDataProperties.swift
//  FriendFace
//
//  Created by David Liongson on 11/12/20.
//
//

import Foundation
import CoreData


extension UserModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserModel> {
        return NSFetchRequest<UserModel>(entityName: "UserModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var friends: NSSet?

    public var wrappedRegistered: Date {
        registered ?? Date()
    }
    
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var wrappedAddress: String {
        address ?? "Unknown Address"
    }
    
    public var wrappedEmail: String {
        email ?? "Unknown Email"
    }
    
    public var friendsArray: [FriendModel] {
        let set = friends as? Set<FriendModel> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
}

// MARK: Generated accessors for friends
extension UserModel {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: FriendModel)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: FriendModel)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension UserModel : Identifiable {

}
