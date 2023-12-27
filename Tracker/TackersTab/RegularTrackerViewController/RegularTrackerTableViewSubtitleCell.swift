
import UIKit

// MARK: - Regular Tracker TableViewSubtitleCell Class

final class RegularTrackerTableViewSubtitleCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "cell"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(
        with title: String,
        categorySubtitle: String,
        scheduleSubtitle: String,
        isFirstRow: Bool
    ) {
        textLabel?.text = title
        textLabel?.font = UIFont.TrackerFont.regular17
        textLabel?.textColor = UIColor.TrackerColor.black
        
        detailTextLabel?.font = UIFont.TrackerFont.regular17
        detailTextLabel?.textColor = UIColor.TrackerColor.gray
        
        backgroundColor = UIColor.TrackerColor.background
        layer.masksToBounds = true
        layer.cornerRadius = 16
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        if isFirstRow {
            detailTextLabel?.text = categorySubtitle
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            detailTextLabel?.text = scheduleSubtitle
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width + 40)
        }
    }
}
