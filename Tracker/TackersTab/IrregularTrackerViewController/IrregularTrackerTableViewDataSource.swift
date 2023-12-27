
import UIKit

// MARK: - Irregular Tracker TableViewDataSource Class

final class IrregularTrackerTableViewDataSource: NSObject & UITableViewDataSource {
    
    // MARK: - Properties
    
    private weak var viewController: IrregularTrackerViewController?
    
    // MARK: - Initializers
    
    init(viewController: IrregularTrackerViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewController?.getTitles().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: IrregularTrackerTableViewSubtitleCell.reuseIdentifier,
            for: indexPath
        )
        
        guard
            let viewController,
            let categoryCell = cell as? IrregularTrackerTableViewSubtitleCell
        else {
            return UITableViewCell()
        }
        
        let title = viewController.getTitles()[indexPath.row]
        let categorySubtitle = viewController.getCategorySubtitle()
        
        categoryCell.configure(
            with: title,
            categorySubtitle: categorySubtitle
        )
        
        return categoryCell
    }
}
