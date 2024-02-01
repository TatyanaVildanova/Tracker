import UIKit

final class CategoryViewController: UIViewController {
    
    private let cellReuseIdentifier = "HabitCategoryViewController"
    private(set) var viewModel: CategoryViewModel = CategoryViewModel.shared
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var emptyCategoryPlaceholder: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "EmptyCollectionIcon")
        return imageView
    }()
    
    private lazy var emptyCategoryText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private lazy var addCategory: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(addCategoryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupSubviews()
        setupCategoriesTableView()
    }
    

    private func setupSubviews() {
        view.addSubview(header)
        view.addSubview(emptyCategoryPlaceholder)
        view.addSubview(emptyCategoryText)
        view.addSubview(addCategory)
        view.addSubview(categoriesTableView)
                
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoriesTableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 38),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: addCategory.topAnchor, constant: -16),
            emptyCategoryPlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCategoryPlaceholder.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 246),
            emptyCategoryPlaceholder.heightAnchor.constraint(equalToConstant: 80),
            emptyCategoryPlaceholder.widthAnchor.constraint(equalToConstant: 80),
            emptyCategoryText.centerXAnchor.constraint(equalTo: emptyCategoryPlaceholder.centerXAnchor),
            emptyCategoryText.topAnchor.constraint(equalTo: emptyCategoryPlaceholder.bottomAnchor, constant: 8),
            addCategory.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategory.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupCategoriesTableView() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.register(CategoryCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        updateUIBasedOnData()
    }
    
    private func updateUIBasedOnData() {
        let isDataEmpty = viewModel.categories.isEmpty
        categoriesTableView.isHidden = isDataEmpty
        emptyCategoryPlaceholder.isHidden = !isDataEmpty
        emptyCategoryText.isHidden = !isDataEmpty
    }
    
    @objc private func addCategoryTapped() {
        let createCategoryVC = CreateCategoryViewController()
        createCategoryVC.categoryViewController = self
        present(createCategoryVC, animated: true)
    }
}

// MARK: - CategoryActions

extension CategoryViewController: CategoryAddition {
    func appendCategory(category: String) {
        viewModel.addCategory(category)
        categoriesTableView.isHidden = false
        emptyCategoryPlaceholder.isHidden = true
        emptyCategoryText.isHidden = true
    }
    
    func reload() {
        self.categoriesTableView.reloadData()
    }
}

// MARK: - Delegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.categories.count else {
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell {
            cell.done(with: UIImage(named: "CheckMark") ?? UIImage())
            viewModel.selectCategory(indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let separatorInset: CGFloat = 16
        let separatorWidth = tableView.bounds.width - separatorInset * 2
        let separatorHeight: CGFloat = 1.0
        let separatorX = separatorInset
        let separatorY = cell.frame.height - separatorHeight
        
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        if !isLastCell {
            let separatorView = UIView(frame: CGRect(x: separatorX, y: separatorY, width: separatorWidth, height: separatorHeight))
            separatorView.backgroundColor = .ypLightGray
            cell.addSubview(separatorView)
        }
    }
}

// MARK: - DataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CategoryCell else { return UITableViewCell() }
        
        if indexPath.row < viewModel.categories.count {
            let category = viewModel.categories[indexPath.row]
            cell.update(with: category.header)
            if let selected = viewModel.selectedCategory {
                if selected.header == category.header {
                    cell.done(with: UIImage(named: "CheckMark") ?? UIImage())
                }
            }
            
            let isLastCell = indexPath.row == viewModel.categories.count - 1
            if isLastCell {
                cell.layer.cornerRadius = 16
                cell.layer.masksToBounds = true
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.layer.cornerRadius = 0
                cell.layer.masksToBounds = false
            }
        }
        return cell
    }
}
