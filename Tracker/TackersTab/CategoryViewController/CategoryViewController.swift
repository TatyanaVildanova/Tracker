  
import UIKit

// MARK: - Category ViewController Class

final class CategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            CategoryTableViewCell.self,
            forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier
        )
        return tableView
    }()
    
    private lazy var appendCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .standardButton, for: "Добавить категорию")
        button.addTarget(self, action: #selector(appendCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var placeholderView: UIView = {
        PlaceholderView(
            image: UIImage.TrackerIcon.emptyTrackers,
            title: "Привычки и события можно объединить по смыслу"
        )
    }()
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    
    private var listOfCategories: [TrackerCategory] = []
    private var categoryTitle: String = ""

    private var tableViewDataSource: CategoryTableViewDataSource?
    private var tableViewDelegate: CategoryTableViewDelegate?
    
    var selectedIndexPath: IndexPath?
    weak var delegate: UpdateTrackerInformationDelegate?
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white
        
        trackerCategoryStore.setDelegate(self)
        getCategories()
        
        tableViewDataSource = CategoryTableViewDataSource(viewController: self)
        tableViewDelegate = CategoryTableViewDelegate(viewController: self)
        
        addSubviews()
        checkCategories()
    }
    
    // MARK: - Methods
    
    private func addSubviews() {
        addTopNavigationLabel()
        addPlaceholderView()
        addAppendCategoryButton()
        addCategoryTableView()
    }
    
    private func getCategories() {
        do {
            listOfCategories = try trackerCategoryStore.getCategories()
        } catch {
            assertionFailure("Failed to get categories with \(error)")
        }
    }
    
    private func checkCategories() {
        
        if listOfCategories.isEmpty {
            placeholderView.isHidden = false
            categoryTableView.isHidden = true
        } else {
            categoryTableView.isHidden = false
            placeholderView.isHidden = true
        }
    }

    func getListOfCategories() -> [TrackerCategory] {
        listOfCategories
    }
    
    func getCategoryTitle(_ title: String) -> String {
        categoryTitle = title
        return categoryTitle
    }
    
    // MARK: - Objective-C methods
   
    @objc private func appendCategoryButtonTapped() {
        let createCategoryViewController = CreateCategoryViewController()
        createCategoryViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: createCategoryViewController)
        present(navigationController, animated: true)
    }
}

// MARK: - Add Subviews

private extension CategoryViewController {
    
    func addTopNavigationLabel() {
        title = "Категория"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.TrackerFont.medium16,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addCategoryTableView() {
        view.addSubview(categoryTableView)
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTableView.bottomAnchor.constraint(equalTo: appendCategoryButton.topAnchor, constant: -16),
            categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func addPlaceholderView() {
        view.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalToConstant: 200),
            placeholderView.heightAnchor.constraint(equalToConstant: 200),
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func addAppendCategoryButton() {
        view.addSubview(appendCategoryButton)
        
        NSLayoutConstraint.activate([
            appendCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            appendCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            appendCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Delegate methods

extension CategoryViewController: CreateCategoryViewControllerDelegate {
    func updateListOfCategories(with category: TrackerCategory) {
        do {
            try trackerCategoryStore.addCategory(category)
        } catch {
            assertionFailure("Failed to add category with \(error)")
        }
        checkCategories()
    }
}

extension CategoryViewController: TrackerCategoryStoreDelegate {
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        getCategories()
        categoryTableView.performBatchUpdates {
            categoryTableView.insertRows(at: update.insertedIndexPaths, with: .automatic)
            categoryTableView.deleteRows(at: update.deletedIndexPaths, with: .automatic)
        }
    }
}
