// MARK: ЭКРАН СТАТИСТИКИ

import UIKit

final class StatisticViewController: UIViewController {
    
    let cellReuseIdentifier = "StatisticViewController"
    
    // Хранилище трекеров
    var trackerStore = TrackerStore.shared
    // Хранилище выполненных трекеров
    var trackerRecordStore = TrackerRecordStore.shared
    
    // MARK: - UI Elements
    
    // Заголовок
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "Статистика"
        mainLabel.textColor = .ypBlack
        mainLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return mainLabel
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let image = UIImage(named: "EmptyStatisticIcon")
        let emptyCollectionIcon = UIImageView(image: image)
        return emptyCollectionIcon
    }()
    
    // Подпись под картинкой-заглушкой
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let statisticTableView: UITableView = {
        let statisticTableView = UITableView()
        statisticTableView.separatorStyle = .none
        statisticTableView.layer.cornerRadius = 16
        statisticTableView.backgroundColor = .clear
        statisticTableView.isScrollEnabled = false
        statisticTableView.translatesAutoresizingMaskIntoConstraints = false
        return statisticTableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        addSubviews()
        
        reloadPlaceholder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statisticTableView.reloadData()
    }
    
    // MARK: - UI Elements Layout
    
    private func addSubviews() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        statisticTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainLabel)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        view.addSubview(statisticTableView)
        
        // Задаем делегата и датасоурс для коллекции
        statisticTableView.dataSource = self
        statisticTableView.delegate = self
        
        // Регистрируем ячейку для таблицы
        statisticTableView.register(StatisticCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            
            statisticTableView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 77),
            statisticTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticTableView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    private func reloadPlaceholder() {
        if trackerStore.trackers.count > 0 {
            placeholderImage.isHidden = true
            placeholderLabel.isHidden = true
            statisticTableView.isHidden = false
        } else {
            placeholderImage.isHidden = false
            placeholderLabel.isHidden = false
            statisticTableView.isHidden = true
        }
    }
}

// MARK: - UITableViewDelegate

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
}


// MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? StatisticCell else { return UITableViewCell() }
        
        var title = ""
        
        switch indexPath.row {
        case 0:
            title = "Лучший период"
        case 1:
            title = "Идеальные дни"
        case 2:
            title = "Трекеров завершено"
        case 3:
            title = "Среднее значение"
        default:
            break
        }
        
        reloadPlaceholder()
        
        var count = ""
        
        switch indexPath.row {
        case 0:
            count = "0"
        case 1:
            count = "0"
        case 2:
            count = "\(trackerRecordStore.trackerRecords.count ?? 0)"
        case 3:
            count = "0"
        default:
            break
        }
        
        cell.update(with: title, count: count)
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}

