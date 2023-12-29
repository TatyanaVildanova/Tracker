
import UIKit

//MARK: - Trackers ViewController Class

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.TrackerColor.black
        button.setImage(UIImage.TrackerIcon.add, for: .normal)
        button.addTarget(self, action: #selector(addTrackerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        datePicker.calendar.firstWeekday = 2
        datePicker.layer.cornerRadius = 8
        datePicker.clipsToBounds = true
        datePicker.addTarget(self, action: #selector(datePickerDateChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.heightAnchor.constraint(equalToConstant: 34).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: 110).isActive = true
        return datePicker
    }()
    
    private lazy var searchBar: TrackerSearchBar = {
        let searchBar = TrackerSearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.addTarget(self, action: #selector(searchBarTapped), for: .editingDidEndOnExit)
        return searchBar
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dataSource = dataSource
        view.delegate = delegate
        view.allowsMultipleSelection = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.TrackerColor.blue
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.tintColor = UIColor.TrackerColor.white
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.font = UIFont.TrackerFont.regular17
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var placeholderView: UIView = {
        PlaceholderView(
            image: UIImage.TrackerIcon.emptyTrackers,
            title: "Что будем отслеживать?"
        )
    }()
    
    private lazy var filteredPlaceholderView: UIView = {
        PlaceholderView(
            image: UIImage.TrackerIcon.notFounded,
            title: "Ничего не найдено"
        )
    }()
    
    private let trackerStore: TrackerStoreProtocol = TrackerStore()
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    private let trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore()
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var currentDate: Date?
    
    private var dataSource: TrackerCollectionViewDataSource?
    private var delegate: TrackerCollectionViewDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white
        
        trackerStore.setDelegate(self)
        dataSource = TrackerCollectionViewDataSource(viewController: self)
        delegate = TrackerCollectionViewDelegate(viewController: self)
        
        addSubviews()
        reloadData()
    }
    
    // MARK: - Methods
    
    private func addSubviews() {
        addNavigationBar()
        addSearchTrackersTextField()
        addFilterButton()
        addTrackersCollectionView()
        addPlaceholderView(placeholderView)
    }
    
    private func reloadData() {
        do {
            categories = try trackerCategoryStore.getCategories()
        } catch {
            assertionFailure("Failed to get categories with \(error)")
        }
        datePickerDateChanged()
    }
    
    private func updatePlaceholderViews() {
        if !categories.isEmpty && visibleCategories.isEmpty {
            addPlaceholderView(filteredPlaceholderView)
            filterButton.isHidden = false
            placeholderView.isHidden = true
            collectionView.isHidden = true
        } else if categories.isEmpty {
            placeholderView.isHidden = false
            filteredPlaceholderView.isHidden = true
        } else {
            placeholderView.isHidden = true
            collectionView.isHidden = false
        }
        
        filteredPlaceholderView.isHidden = !visibleCategories.isEmpty
        filterButton.isHidden = visibleCategories.isEmpty
    }
    
    private func filterCategories() -> [TrackerCategory] {
        currentDate = datePicker.date
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: currentDate ?? Date())
        let filterText = (searchBar.searchTextField.text ?? "").lowercased()
        
        return categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.title.lowercased().contains(filterText)
                
                let dateCondition = tracker.schedule?.contains { weekday in
                    weekday.weekdayNumber == filterWeekday
                } ?? false
                
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(title: category.title, trackers: trackers)
        }
    }
    
    private func reloadVisibleCategories() {
        visibleCategories = filterCategories()
        updatePlaceholderViews()
        collectionView.reloadData()
    }
    
    func getVisibleCategories() -> [TrackerCategory] {
        visibleCategories
    }
    
    func getRecords(for tracker: Tracker) -> [TrackerRecord] {
        do {
            return try trackerRecordStore.fetchRecords(for: tracker)
        } catch {
            assertionFailure("Failed to get records for tracker")
            return []
        }
    }
 
    // MARK: - Objective-C methods
    
    @objc private func addTrackerButtonTapped() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func datePickerDateChanged() {
        reloadVisibleCategories()
    }
    
    @objc private func searchBarTapped() {
        reloadVisibleCategories()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func filterButtonTapped() {
        print("Filter button tapped")
    }
}

// MARK: - Add Subviews

private extension TrackersViewController {
    
    func addNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.TrackerFont.bold34,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
        
    func addSearchTrackersTextField() {
        view.addSubview(searchBar)
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    func addTrackersCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34),
            collectionView.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            TrackerCollectionViewSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewSectionHeader.reuseIdentifier
        )
    }
    
    func addFilterButton() {
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func addPlaceholderView(_ placeholder: UIView) {
        view.addSubview(placeholder)
        
        NSLayoutConstraint.activate([
            placeholder.widthAnchor.constraint(equalToConstant: 200),
            placeholder.heightAnchor.constraint(equalToConstant: 200),
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - SearchBarDelegate methods

extension TrackersViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        reloadVisibleCategories()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reloadVisibleCategories()
        searchBar.resignFirstResponder()
    }
}

// MARK: - Delegate methods

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        currentDate = datePicker.date
        
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: currentDate ?? Date())
        return trackerRecord.trackerId == id && isSameDay
    }
    
    func isTrackerCompletedToday(id: UUID, tracker: Tracker) -> Bool {
        do {
            return try trackerRecordStore.fetchRecords(for: tracker).contains { trackerRecord in
                isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
            }
        } catch {
            assertionFailure("Failed to get records for tracker")
            return false
        }
    }
    
    func getSelectedDate() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: datePicker.date)
        guard let selectedDate = calendar.date(from: dateComponents) else { return Date() }
        return selectedDate
    }
    
    func reloadTrackersWithCategory() {
        reloadData()
    }
    
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerId: id, date: getSelectedDate())
        try? trackerRecordStore.addRecord(with: trackerRecord.trackerId, by: trackerRecord.date)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerId: id, date: getSelectedDate())
        try? trackerRecordStore.deleteRecord(with: trackerRecord.trackerId, by: trackerRecord.date)
        collectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: TrackerStoreDelegate {
    
    func didUpdate(_ update: TrackerStoreUpdate) {
        collectionView.performBatchUpdates {
            collectionView.insertSections(update.insertedSections)
            collectionView.insertItems(at: update.insertedIndexPaths)
        }
    }
}
