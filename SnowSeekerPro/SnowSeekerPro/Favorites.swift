//
//  Favorites.swift
//  SnowSeekerPro
//
//  Created by David Liongson on 4/4/21.
//

import SwiftUI

class Favorites: ObservableObject {
    
    // the actual resorts the user has favorited
    private var resorts: Set<String>
    
    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"
    
    init() {
        self.resorts = []
        
        //load our saved data
        if let savedFavorites = UserDefaults.standard.object(forKey: saveKey) as? Data {
            let decoder = JSONDecoder()
            
            if let loadedFavorites = try? decoder.decode(Set<String>.self, from: savedFavorites) {
                resorts = loadedFavorites
            }
        }
    }
    
    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        // write our data
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(resorts) {
            let defaults = UserDefaults.standard
            defaults.setValue(encoded, forKey: saveKey)
        }
    }
}
