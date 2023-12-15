//
//  TrackerCategoryExtension.swift
//  Tracker
//
//  Created by TATIANA VILDANOVA on 12.12.2023.
//

import UIKit

extension TrackerCategory {
    static let sampleData: [TrackerCategory] = [
        TrackerCategory(
            label: "Домашний уют",
            trackers: [
                Tracker(
                    label: "Поливать растения",
                    emoji: "❤️",
                    color: UIColor(named: "ColorS5")!,
                    schedule: [.saturday]
                )
            ]
        )
    ]
}
