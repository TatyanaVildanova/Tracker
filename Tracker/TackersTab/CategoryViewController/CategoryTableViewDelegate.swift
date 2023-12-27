
import UIKit

// MARK: - Category TableViewDelegate Class

final class CategoryTableViewDelegate: NSObject & UITableViewDelegate {
    
    // MARK: - Properties
    
    private weak var viewController: CategoryViewController?
    
    // MARK: - Initializers
    
    init(viewController: CategoryViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController else { return }
        
        viewController.selectedIndexPath.flatMap { tableView.cellForRow(at: $0) }?.accessoryType = .none

        viewController.selectedIndexPath = indexPath

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        let titleCategory = viewController.getCategoryTitle(viewController.getListOfCategories()[indexPath.row].title)
        viewController.delegate?.updateCategorySubtitle(
            from: titleCategory,
            at: viewController.selectedIndexPath
        )
    }
}
