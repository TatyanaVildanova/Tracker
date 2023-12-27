
import UIKit

// MARK: - Regular Tracker TableViewDataSource Class

final class RegularTrackerTableViewDataSource: NSObject & UITableViewDataSource {
    
    // MARK: - Properties
    
    private weak var viewController: RegularTrackerViewController?
    
    // MARK: - Initializers
    
    init(viewController: RegularTrackerViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewController?.getTitles().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RegularTrackerTableViewSubtitleCell.reuseIdentifier,
            for: indexPath
        )
        
        guard
            let viewController,
            let itemCell = cell as? RegularTrackerTableViewSubtitleCell
        else {
            return UITableViewCell()
        }
        
        
        let title = viewController.getTitles()[indexPath.row]
        let categorySubtitle = viewController.getCategorySubtitle()
        let scheduleSubtitle = viewController.getScheduleSubtitle(from: viewController.getSchedule())
        let isFirstRow = indexPath.row == 0
        
        itemCell.configure(
            with: title,
            categorySubtitle: categorySubtitle,
            scheduleSubtitle: scheduleSubtitle,
            isFirstRow: isFirstRow
        )
        
        return itemCell
    }
}
