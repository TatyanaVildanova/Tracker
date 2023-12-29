
import UIKit

extension UIButton {
    enum TrackerButton {
        case createButton
        case cancelButton
        case standardButton
        
        var backgroundColor: UIColor {
            switch self {
            case .createButton:
                return UIColor.TrackerColor.gray
            case .cancelButton:
                return UIColor.TrackerColor.white
            case .standardButton:
                return UIColor.TrackerColor.black
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .cancelButton:
                return UIColor.TrackerColor.red
            default:
                return UIColor.TrackerColor.white
            }
        }
        
        var font: UIFont {
            switch self {
            default:
                return UIFont.TrackerFont.medium16
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            default:
                return 16
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .cancelButton:
                return 1
            default:
                return 0
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .cancelButton:
                return UIColor.TrackerColor.red
            default:
                return .clear
            }
        }
    }
    
    func configure(with trackerButton: TrackerButton, for title: String) {
        backgroundColor = trackerButton.backgroundColor
        
        setTitle(title, for: .normal)
        setTitleColor(trackerButton.titleColor, for: .normal)
        titleLabel?.font = trackerButton.font
        
        layer.cornerRadius = trackerButton.cornerRadius
        layer.masksToBounds = true
        layer.borderWidth = trackerButton.borderWidth
        layer.borderColor = trackerButton.borderColor.cgColor
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
