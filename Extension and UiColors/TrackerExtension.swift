//
//  TrackerExtension.swift
//  Tracker
//
//  Created by TATIANA VILDANOVA on 12.12.2023.
//

import Foundation

extension Tracker {
    struct Data {
        var label: String = ""
        var emoji: String? = nil
        var color: UIColor? = nil
        var schedule: [Weekday]? = nil
    }
}
