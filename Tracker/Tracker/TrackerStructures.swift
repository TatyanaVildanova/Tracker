import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
    let pinned: Bool
    let colorIndex: Int
}

struct TrackerCategory {
    let header: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let id: UUID
    let date: Date
}
