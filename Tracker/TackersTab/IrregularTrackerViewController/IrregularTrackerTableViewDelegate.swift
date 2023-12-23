
import UIKit

// MARK: - Irregular Tracker TableViewDelegate Class

final class IrregularTrackerTableViewDelegate: NSObject & UITableViewDelegate {
    
    // MARK: - Properties
    
    private weak var viewController: IrregularTrackerViewController?
    
    // MARK: - Initializers
    
    init(viewController: IrregularTrackerViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController else { return }
        
        let categoryViewController = CategoryViewController()
        categoryViewController.delegate = viewController
        categoryViewController.selectedIndexPath = viewController.indexCategory
        
        let navigationController = UINavigationController(rootViewController: categoryViewController)
        viewController.present(navigationController, animated: true)
    }
}
