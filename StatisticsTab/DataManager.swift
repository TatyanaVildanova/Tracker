
import UIKit

final class DataManager {
    static let shared = DataManager()

    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Хобби",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Порисовать",
                    color: UIColor.TrackerColor.colorSelection1,
                    emoji: "🎸",
                    schedule: [Weekday.monday, Weekday.wednesday, Weekday.friday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Покататься на роликах",
                    color: UIColor.TrackerColor.colorSelection18,
                    emoji: "🚴‍♂️",
                    schedule: Weekday.allCases
                )
            ]
        ),
        TrackerCategory(
            title: "Здоровье",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Прием у ортодонта",
                    color: UIColor.TrackerColor.colorSelection3,
                    emoji: "🦷",
                    schedule: [Weekday.friday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Прием у пластического хирурга",
                    color: UIColor.TrackerColor.colorSelection7,
                    emoji: "👨🏻‍⚕️",
                    schedule: [Weekday.sunday]
                )
            ]
        )
    ]
    
    func add(categories: [TrackerCategory]) {
        self.categories.append(contentsOf: categories)
    }
    
    private init() {}
}

