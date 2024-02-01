import Foundation

extension Int {
    
    // Метод для определения написания количества дней (день / дня / дней)
    func pluralizeDays() -> String {
            let remainder10 = self % 10
            let remainder100 = self % 100
            
            if remainder10 == 1 && remainder100 != 11 {
                return String.localizedStringWithFormat(NSLocalizedString("day", comment: ""), self)
            } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
                return String.localizedStringWithFormat(NSLocalizedString("days", comment: ""), self)
            } else {
                return String.localizedStringWithFormat(NSLocalizedString("manydays", comment: ""), self)
            }
        }
}

