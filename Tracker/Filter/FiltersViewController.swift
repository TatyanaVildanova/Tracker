import UIKit

enum FilterType {
    case all, today, completed, notCompleted
}

protocol FiltersViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: FilterType)
    func didSelectCurrentDay()
    func didSelectFilterAtIndex(_ indexPath: IndexPath)
}

final class FiltersViewController: UIViewController {
    
    weak var delegate: FiltersViewControllerDelegate?
    
    private let cellReuseIdentifier = "FiltersViewController"
    var selectedIndexPath: IndexPath?   // Галочка для ячеек. На первой ячейке по умолчанию
    private let filters = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]

    
    // MARK: - UI Elements
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Фильтры"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var filtersTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func setupSubviews() {
        view.addSubview(header)
        view.addSubview(filtersTableView)
        
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.register(FiltersCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersTableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 24),
            filtersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -374),
        ])
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        setupSubviews()
    }
}

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < filters.count else {
            return
        }
        if let prevIndexPath = selectedIndexPath, let prevCell = tableView.cellForRow(at: prevIndexPath) as? FiltersCell {
            prevCell.done(with: UIImage())
        }
        
        // Устанавливаем изображение галочки для выбранной ячейки
        if let cell = tableView.cellForRow(at: indexPath) as? FiltersCell {
            cell.done(with: UIImage(named: "CheckMark") ?? UIImage())
            tableView.deselectRow(at: indexPath, animated: true)
            
            // Устанавливаем текущий фильтр в зависимости от выбранной ячейки
            var filter: FilterType
            switch filters[indexPath.row] {
            case "Все трекеры":
                filter = .all
            case "Трекеры на сегодня":
                // currentDate = Date() // Устанавливаем текущую дату
                filter = .today
            case "Завершенные":
                filter = .completed
            case "Не завершенные":
                filter = .notCompleted
            default:
                filter = .all
            }

            switch filter {
            case .today: delegate?.didSelectCurrentDay()
            default: delegate?.didSelectFilter(filter)
            }
        }
        
        selectedIndexPath = indexPath
        delegate?.didSelectFilterAtIndex(indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FiltersCell

        cell.titleLabel.text = filters[indexPath.row]
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        
        if indexPath == selectedIndexPath {
            cell.done(with: UIImage(named: "CheckMark") ?? UIImage())
        } else {
            cell.done(with: UIImage())
        }
        
        return cell
    }
}

