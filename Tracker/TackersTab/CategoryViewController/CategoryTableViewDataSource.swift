
import UIKit

// MARK: - Category TableViewDataSource Class

final class CategoryTableViewDataSource: NSObject & UITableViewDataSource {
    
    // MARK: - Properties
    
    private weak var viewController: CategoryViewController?
    
    // MARK: - Initializers
    
    init(viewController: CategoryViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController?.getListOfCategories().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        )
        
        guard
            let unwrappedViewController = viewController,
            let categoryCell = cell as? CategoryTableViewCell
        else {
            return UITableViewCell()
        }
        
        let category = unwrappedViewController.getListOfCategories()[indexPath.row]
        let title = category.title
        let isFirstRow = indexPath.row == 0
        let isLastRow = indexPath.row == unwrappedViewController.getListOfCategories().count - 1
        let isSelected = indexPath == unwrappedViewController.selectedIndexPath

        let viewModel = CategoryTableViewCellViewModel(
            title: title,
            isFirstRow: isFirstRow,
            isLastRow: isLastRow,
            isSelected: isSelected
        )
        categoryCell.configure(with: viewModel)
        
        return categoryCell
    }
}

