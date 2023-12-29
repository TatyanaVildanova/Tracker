
import UIKit

// MARK: - Irregular Tracker TableViewSubtitleCell Class

final class IrregularTrackerTableViewSubtitleCell: UITableViewCell {
    
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
        categorySubtitle: String
    ) {
        textLabel?.text = title
        textLabel?.font = UIFont.TrackerFont.regular17
        textLabel?.textColor = UIColor.TrackerColor.black
        
        detailTextLabel?.text = categorySubtitle
        detailTextLabel?.font = UIFont.TrackerFont.regular17
        detailTextLabel?.textColor = UIColor.TrackerColor.gray
        
        backgroundColor = UIColor.TrackerColor.background
        layer.masksToBounds = true
        layer.cornerRadius = 16
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
}
