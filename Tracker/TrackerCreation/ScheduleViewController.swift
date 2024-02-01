import UIKit

final class ScheduleViewController: UIViewController {
    
    var selectedDays = [WeekDay]()
    weak var delegate: ScheduleDelegate?
    
    // MARK: UI ELEMENTS
    
    private let navBar = UINavigationBar()
    
    private let weekDayTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        weekDayTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleTableViewCell")
        
        navBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 49)
        navBar.barTintColor = .ypWhite
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        view.addSubview(navBar)
        let navTitle = UINavigationItem(title: "Расписание")
        navBar.setItems([navTitle], animated: false)
        
        addSubviews()
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        if let day = WeekDay(rawValue: sender.tag + 1) {
            if sender.isOn {
                selectedDays.append(day)
            } else {
                if let index = selectedDays.firstIndex(of: day) {
                    selectedDays.remove(at: index)
                }
            }
        }
    }
    
    @objc private func doneButtonTapped() {
        delegate?.weekDaysChanged(weedDays: selectedDays)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: LAYOUT
    
    private func addSubviews() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        weekDayTableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weekDayTableView)
        view.addSubview(doneButton)
        
        weekDayTableView.dataSource = self
        weekDayTableView.delegate = self
        
        NSLayoutConstraint.activate([
            weekDayTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 16),
            weekDayTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekDayTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekDayTableView.widthAnchor.constraint(equalToConstant: 75),
            weekDayTableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: EXTENSIONS

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        
        let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
        
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        
        let switchView = UISwitch(frame: .zero)
        switchView.onTintColor = .ypBlue
        switchView.tag = indexPath.row // Важно: сохраняем номер строки как тег
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        if let currentWeekDay = WeekDay(rawValue: indexPath.row + 1),
           selectedDays.contains(currentWeekDay) {
            switchView.setOn(true, animated: false)
        }
        cell.accessoryView = switchView
        

        if indexPath.row == daysOfWeek.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

