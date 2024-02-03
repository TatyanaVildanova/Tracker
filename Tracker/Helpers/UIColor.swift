import UIKit

extension UIColor {
    
    static var ypBackground: UIColor {
        if let color = UIColor(named: "YP Background") {
            return color
        } else {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 0.85)
                } else {
                    return UIColor(red: 0.902, green: 0.910, blue: 0.922, alpha: 0.30)
                }
            }
        }
    }
    
    static var ypBlack: UIColor {
        if let color = UIColor(named: "YP Black") {
            return color
        } else {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    return UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
                }
            }
        }
    }
    
    static var ypWhite: UIColor {
        if let color = UIColor(named: "YP White") {
            return color
        } else {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
                } else {
                    return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    static var ypBlue: UIColor { UIColor(named: "YP Blue") ?? UIColor.blue }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var ypLightGray: UIColor { UIColor(named: "YP LightGray") ?? UIColor.lightGray }
    
    static var colorSelection1: UIColor { UIColor(named: "Color selection 1")! }
    static var colorSelection2: UIColor { UIColor(named: "Color selection 2")! }
    static var colorSelection3: UIColor { UIColor(named: "Color selection 3")! }
    static var colorSelection4: UIColor { UIColor(named: "Color selection 4")! }
    static var colorSelection5: UIColor { UIColor(named: "Color selection 5")! }
    static var colorSelection6: UIColor { UIColor(named: "Color selection 6")! }
    static var colorSelection7: UIColor { UIColor(named: "Color selection 7")! }
    static var colorSelection8: UIColor { UIColor(named: "Color selection 8")! }
    static var colorSelection9: UIColor { UIColor(named: "Color selection 9")! }
    static var colorSelection10: UIColor { UIColor(named: "Color selection 10")! }
    static var colorSelection11: UIColor { UIColor(named: "Color selection 11")! }
    static var colorSelection12: UIColor { UIColor(named: "Color selection 12")! }
    static var colorSelection13: UIColor { UIColor(named: "Color selection 13")! }
    static var colorSelection14: UIColor { UIColor(named: "Color selection 14")! }
    static var colorSelection15: UIColor { UIColor(named: "Color selection 15")! }
    static var colorSelection16: UIColor { UIColor(named: "Color selection 16")! }
    static var colorSelection17: UIColor { UIColor(named: "Color selection 17")! }
    static var colorSelection18: UIColor { UIColor(named: "Color selection 18")! }
    
    func hexString() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
    
    static func color(from hex: String?) -> UIColor? {
        guard let hex else { return nil }
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0))
    }
            
    static func from(data: Data?) -> UIColor? {
        guard let data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
    
    func encode() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

