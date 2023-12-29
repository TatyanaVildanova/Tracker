
import UIKit

// MARK: - Regular Tracker TableViewDelegate Class

final class RegularTrackerTableViewDelegate: NSObject & UITableViewDelegate {
    
    // MARK: - Properties
    
    private weak var viewController: RegularTrackerViewController?
    
    // MARK: - Initializers
    
    init(viewController: RegularTrackerViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    private func presentViewController(for viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        self.viewController?.present(navigationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController else { return }
        
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = viewController
            categoryViewController.selectedIndexPath = viewController.indexCategory
            presentViewController(for: categoryViewController)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = viewController
            scheduleViewController.schedule = viewController.getSchedule()
            scheduleViewController.selectedWeekdays = viewController.getSelectedWeekdays()
            presentViewController(for: scheduleViewController)
        }
    }
}

