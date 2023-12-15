//
//  TrackerCategory.swift
//  Tracker
//
//  Created by TATIANA VILDANOVA on 12.12.2023.
//

import UIKit

struct TrackerCategory {
    let label: String
    let trackers: [Tracker]
    
    init(label: String, trackers: [Tracker]) {
        self.label = label
        self.trackers = trackers
    }
}
