//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by David Liongson on 11/29/20.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown subtitle"
        }
        set {
            subtitle = newValue
        }
    }
}
