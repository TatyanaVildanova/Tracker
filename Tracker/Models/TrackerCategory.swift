import Foundation

struct TrackerCategory {
    let head: String
    let trackers: [Tracker]
    
    init(head: String, trackers: [Tracker]) {
        self.head = head
        self.trackers = trackers    }
}

