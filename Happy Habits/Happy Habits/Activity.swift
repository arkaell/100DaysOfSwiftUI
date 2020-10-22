//
//  Activity.swift
//  Happy Habits
//
//  Created by David Liongson on 10/16/20.
//

import Foundation

struct Activity: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var completions: Int = 0
    
    mutating func incrementCompletions() {
        self.completions += 1
    }
}

class Habits: ObservableObject {
    @Published var activities: [Activity] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let activities = UserDefaults.standard.data(forKey: "Activities") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Activity].self, from: activities) {
                self.activities = decoded
                return
            }
        }
        
        self.activities = []
    }
}
