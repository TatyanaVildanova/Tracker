import UIKit

// MARK: - Category TableViewCell Class

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "category"
    
    // MARK: - Methods
    
    func configure(
        with title: String,
        isFirstRow: Bool,
        isLastRow: Bool,
        isSelected: Bool
    ) {
        textLabel?.text = title
        textLabel?.font = UIFont.TrackerFont.regular17
        textLabel?.textColor = UIColor.TrackerColor.black
        
        backgroundColor = UIColor.TrackerColor.background
        layer.masksToBounds = true
        layer.cornerRadius = 16
        
        selectionStyle = .none
        accessoryType = isSelected ? .checkmark : .none
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        if isFirstRow && isLastRow {
            layer.cornerRadius = 16
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width + 40)
        } else if isFirstRow {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLastRow {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width + 40)
        } else {
            layer.cornerRadius = 0
        }
    }
}

