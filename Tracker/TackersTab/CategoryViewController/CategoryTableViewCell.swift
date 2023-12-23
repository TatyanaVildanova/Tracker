
import UIKit

// MARK: - Category TableViewCell ViewModel

struct CategoryTableViewCellViewModel {
    let title: String
    let isFirstRow: Bool
    let isLastRow: Bool
    let isSelected: Bool
}

// MARK: - Category TableViewCell Class

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "category"
    
    // MARK: - Methods
    
    func configure(with viewModel: CategoryTableViewCellViewModel) {
        textLabel?.text = viewModel.title
        textLabel?.font = UIFont.TrackerFont.regular17
        textLabel?.textColor = UIColor.TrackerColor.black

        backgroundColor = UIColor.TrackerColor.background
        layer.masksToBounds = true
        layer.cornerRadius = 16

        selectionStyle = .none
        accessoryType = viewModel.isSelected ? .checkmark : .none
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        if viewModel.isFirstRow && viewModel.isLastRow {
            layer.cornerRadius = 16
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width + 40)
        } else if viewModel.isFirstRow {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if viewModel.isLastRow {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width + 40)
        } else {
            layer.cornerRadius = 0
        }
    }
}

