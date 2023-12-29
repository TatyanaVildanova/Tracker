

import Foundation

enum Weekday: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var weekdayShortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    var weekdayNumber: Int {
        switch self {
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        case .sunday: return 1
        }
    }
    
    static func getString(from weekday: [Weekday]?) -> String? {
        guard let weekday else { return nil }
        return weekday.map { $0.rawValue }.joined(separator: ", ")
    }
    
    static func getWeekday(from string: String?) -> [Weekday]? {
        let array = string?.components(separatedBy: ", ")
        let weekday = Weekday.allCases.filter { array?.contains($0.rawValue) ?? false }
        return weekday.count > 0 ? weekday : nil
    }
}
