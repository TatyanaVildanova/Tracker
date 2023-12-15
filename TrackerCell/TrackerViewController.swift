//
//  TrackerViewController.swift
//  Tracker
//
//  Created by TATIANA VILDANOVA on 12.12.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Properties
    private let options = UICollectionView.GeometricOptions(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 10)
    private var categories: [TrackerCategory] = TrackerCategory.sampleData
    private var searchText = ""
    private var widthAnchor: NSLayoutConstraint?
    private var currentDate = Date.from(date: Date())!
    private var completedTrackers: Set<TrackerRecord> = []
    private var visibleCategories: [TrackerCategory] {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        
        // MARK: -  TrackerCategory
        var result = [TrackerCategory]()
        for category in categories {
            let trackersByDay = category.trackers.filter { tracker in
                guard let schedule = tracker.schedule else { return true }
                return schedule.contains(Weekday.allCases[weekday > 1 ? weekday - 2 : weekday + 5])
            }
            
            if searchText.isEmpty && !trackersByDay.isEmpty {
                result.append(TrackerCategory(label: category.label, trackers: trackersByDay))
            } else {
                let filteredTrackers = trackersByDay.filter { tracker in
                    tracker.label.lowercased().contains(searchText.lowercased())
                }
                
                if !filteredTrackers.isEmpty {
                    result.append(TrackerCategory(label: category.label, trackers: filteredTrackers))
                }
            }
        }
        
        if result.isEmpty {
            notFoundStack.isHidden = !result.isEmpty
            filterButton.isHidden = result.isEmpty
        }
        
        return result
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.tintColor = .blue
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.calendar = Calendar(identifier: .iso8601)
        picker.maximumDate = Date()
        picker.addTarget(self, action: #selector(didChangedDatePicker), for: .valueChanged)
        return picker
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 18,
                    weight: .bold
                )
            )!,
            target: self, action: #selector(didTapPlusButton))
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchBar: UISearchTextField = {
        let searchBar = UISearchTextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return searchBar
    }()
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        view.register(
            TrackerCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        return view
    }()
    
    private let notFoundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "TrackerStart")
        return imageView
    }()
    
    private let notFoundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Что будем отслеживать?"
        label.textColor = .black
        return label
    }()
    
    private let notFoundStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "Blue")
        return button
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
    }
    
    // MARK: - Actions
    @objc
    private func cancelButtonTapped() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    @objc
    private func didTapPlusButton() {
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc
    private func didChangedDatePicker(_ sender: UIDatePicker) {
        currentDate = Date.from(date: sender.date)!
        collectionView.reloadData()
    }
    
    @objc private func searchTextChanged() {
        reloadVisibleCategories()
    }
    
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: currentDate)
        let filterText = (searchBar.text ?? "").lowercased()
    }
}

// MARK: - Layout methods
private extension TrackersViewController {
    func setupContent() {
        view.backgroundColor = .white
        view.addSubview(plusButton)
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(notFoundStack)
        view.addSubview(filterButton)
        
        notFoundStack.addArrangedSubview(notFoundImageView)
        notFoundStack.addArrangedSubview(notFoundLabel)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            plusButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
          
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 13),
          
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
           
            notFoundStack.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            notFoundStack.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
           
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        trackerCell.configure(with: tracker, days: daysCount, isCompleted: isCompleted)
        trackerCell.delegate = self
        return trackerCell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let availableSpace = collectionView.frame.width - options.paddingWidth
        let cellWidth = availableSpace / options.cellCount
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        UIEdgeInsets(top: 8, left: options.leftInset, bottom: 16, right: options.rightInset)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? TrackerCategoryLabel
        else { return UICollectionReusableView() }
        
        let label = visibleCategories[indexPath.section].label
        view.configure(with: label)
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        reloadVisibleCategories()
        
        return true
    }
}


// MARK: - TrackerCellDelegate
extension TrackersViewController: TrackerCellDelegate {
    func didTapCompleteButton(of cell: TrackerCell, with tracker: Tracker) {
        let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        if completedTrackers.contains(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            completedTrackers.remove(trackerRecord)
            cell.toggleCompletedButton(to: false)
            cell.decreaseCount()
        } else {
            completedTrackers.insert(trackerRecord)
            cell.toggleCompletedButton(to: true)
            cell.increaseCount()
        }
    }
}

// MARK: - AddTrackerViewControllerDelegate
extension TrackersViewController: AddTrackerViewControllerDelegate {
    func didSelectTracker(with type: AddTrackerViewController.TrackerType) {
        dismiss(animated: true)
        let trackerFormViewController = TrackerFormViewController(type: type)
        trackerFormViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: trackerFormViewController)
        present(navigationController, animated: true)
    }
}

extension TrackersViewController: TrackerFormViewControllerDelegate {
    func didTapConfirmButton(categoryLabel: String, trackerToAdd: Tracker) {
        dismiss(animated: true)
        guard let categoryIndex = categories.firstIndex(where: { $0.label == categoryLabel }) else { return }
        let updatedCategory = TrackerCategory(
            label: categoryLabel,
            trackers: categories[categoryIndex].trackers + [trackerToAdd]
        )
        categories[categoryIndex] = updatedCategory
        collectionView.reloadData()
    }
    
    func didTapCancelButton() {
        dismiss(animated: true)
    }
}
