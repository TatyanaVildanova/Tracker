//
//  TrackerStruct.swift
//  Tracker
//
//  Created by TATIANA VILDANOVA on 12.12.2023.
//

import Foundation

struct Tracker: Identifiable {
    let id: UUID
    let label: String
    let emoji: String
    let color: UIColor
    let schedule: [Weekday]?
    
    init(id: UUID = UUID(), label: String, emoji: String, color: UIColor, schedule: [Weekday]?) {
        self.id = id
        self.label = label
        self.emoji = emoji
        self.color = color
        self.schedule = schedule
    }
    
    init(tracker: Tracker) {
        self.id = tracker.id
        self.label = tracker.label
        self.emoji = tracker.emoji
        self.color = tracker.color
        self.schedule = tracker.schedule
    }
    
    init(data: Data) {
        guard let emoji = data.emoji, let color = data.color else { fatalError() }
        
        self.id = UUID()
        self.label = data.label
        self.emoji = emoji
        self.color = color
        self.schedule = data.schedule
    }
    
    var data: Data {
        Data(label: label, emoji: emoji, color: color, schedule: schedule)
    }
}
