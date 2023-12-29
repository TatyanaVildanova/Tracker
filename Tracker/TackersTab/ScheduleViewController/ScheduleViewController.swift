
import UIKit

// MARK: - Schedule ViewController Class

final class ScheduleViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.dataSource = dataSource
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            ScheduleTableViewCell.self,
            forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier
        )
        return tableView
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .standardButton, for: "Готово")
        button.backgroundColor = UIColor.TrackerColor.black
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let weekdayList: [Weekday] = Weekday.allCases
    
    private var dataSource: ScheduleTableViewDataSource?
    
    var schedule: [Weekday] = []
    var selectedWeekdays: [Int : Bool] = [:]
    weak var delegate: UpdateTrackerInformationDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white

        dataSource = ScheduleTableViewDataSource(viewController: self)
        
        addSubviews()
    }
    
    // MARK: - Methods
    
    private func addSubviews() {
        addTopNavigationLabel()
        addConfirmButton()
        addScheduleTableView()
    }
    
    func getWeekdays() -> [Weekday] {
        weekdayList
    }
    
    // MARK: - Objective-C methods
    
    @objc private func confirmButtonTapped() {
        delegate?.updateScheduleSubtitle(
            from: schedule,
            at: selectedWeekdays
        )
        
        dismiss(animated: true)
    }
}

// MARK: - Add Subviews

private extension ScheduleViewController {
    
    func addTopNavigationLabel() {
        title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.TrackerFont.medium16,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addScheduleTableView() {
        view.addSubview(scheduleTableView)
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            scheduleTableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -39),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func addConfirmButton() {
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
