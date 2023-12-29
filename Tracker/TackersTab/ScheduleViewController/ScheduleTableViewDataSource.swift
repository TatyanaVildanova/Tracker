import UIKit

// MARK: - Schedule TableViewDataSource Class

final class ScheduleTableViewDataSource: NSObject & UITableViewDataSource {
    
    // MARK: - Properties
    
    private weak var viewController: ScheduleViewController?
    
    // MARK: - Initializers
    
    init(viewController: ScheduleViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewController?.getWeekdays().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleTableViewCell.reuseIdentifier,
            for: indexPath
        )
        
        guard
            let viewController,
            let weekdayCell = cell as? ScheduleTableViewCell
        else {
            return UITableViewCell()
        }
        
        let title = viewController.getWeekdays()[indexPath.row].rawValue
        let isFirstRow = indexPath.row == 0
        let isLastRow = indexPath.row == viewController.getWeekdays().count - 1
        
        weekdayCell.configure(
            with: title,
            isFirstRow: isFirstRow,
            isLastRow: isLastRow
        )
        
        weekdayCell.switchWeekday.tag = indexPath.row
        weekdayCell.switchWeekday.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        if let weekday = viewController.selectedWeekdays[indexPath.row] {
            weekdayCell.switchWeekday.setOn(weekday, animated: true)
        } else {
            weekdayCell.switchWeekday.setOn(false, animated: false)
        }
        
        return weekdayCell
    }
    
    // MARK: - Objective-C methods
    
    @objc private func switchChanged(_ sender: UISwitch) {
        guard let viewController else { return }
        
        let weekdays = Weekday.allCases
        
        // Update the selected weekdays dictionary
        viewController.selectedWeekdays[sender.tag] = sender.isOn
        
        // Update the schedule array based on the selected weekdays
        viewController.schedule = weekdays.enumerated().compactMap { index, weekday in
            viewController.selectedWeekdays[index] == true ? weekday : nil
        }
    }
}

