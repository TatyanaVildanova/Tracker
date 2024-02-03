// MARK: ЭКРАН СОЗДАНИЯ СОБЫТИЯ

import UIKit

final class NewEventViewController: UIViewController {
    
    private let dataManager = DataManager.shared
    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private var selectedCategory: TrackerCategory?

    let currentWeekDay = Calendar.current.component(.weekday, from: Date())
    
    // MARK: - UI ELEMENTS
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let trackerNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    let buttonTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private var emojiCollectionView: EmojiCollectionView!
    private var colorCollectionView: ColorCollectionView!
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    
    let createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypGray
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        trackerNameField.delegate = self
        self.title = "Новое нерегулярное событие"
        addSubviews()
    }
    
    @objc func cancelButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("CloseAllModals"), object: nil)
    }
    
    @objc func createButtonTapped() {
       
        guard let trackerTitle = trackerNameField.text,
              let selectedEmoji = emojiCollectionView.selectedEmoji,
              let selectedColor = colorCollectionView.selectedColor,
              let currentCategory = selectedCategory,
                !trackerTitle.isEmpty else {
            let alertController = UIAlertController(title: "Ой!", message: "Выберите все поля", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "ОК", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return
        }

        let newTracker = Tracker(id: UUID(),
                                 date: Date(),
                                 emoji: selectedEmoji,
                                 title: trackerTitle,
                                 color: selectedColor,
                                 isPinned: false,
                                 dayCount: 1,
                                 schedule: nil)
        
        do {
            try trackerStore.addNewTracker(newTracker)
            try categoryStore.addTrackerToCategory(to: selectedCategory, tracker: newTracker)
            NotificationCenter.default.post(name: NSNotification.Name("CloseAllModals"), object: nil)
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - LAYOUT
    
    private func addSubviews() {
        let layout = UICollectionViewFlowLayout()
        emojiCollectionView = EmojiCollectionView(frame: .zero, collectionViewLayout: layout)
        colorCollectionView = ColorCollectionView(frame: .zero, collectionViewLayout: layout)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        trackerNameField.translatesAutoresizingMaskIntoConstraints = false
        buttonTableView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(trackerNameField)
        scrollView.addSubview(buttonTableView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(createButton)
        
        // Ставим делегата и датасоурс для TableView
        buttonTableView.dataSource = self
        buttonTableView.delegate = self
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Имя трекера
            trackerNameField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            trackerNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerNameField.heightAnchor.constraint(equalToConstant: 75),
            
            // Кнопки Категория / Расписание
            buttonTableView.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 24),
            buttonTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonTableView.heightAnchor.constraint(equalToConstant: 75),
            
            // Коллекция эмодзи
            emojiCollectionView.topAnchor.constraint(equalTo: buttonTableView.bottomAnchor, constant: 16),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            // Коллекция цветов
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 2),
            colorCollectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -40),
            
            // Кнопка Отмена
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Кнопка Создать
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - EXTENSIONS

extension NewEventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ButtonTableViewCell()
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.layer.cornerRadius = 16
        cell.configure(with: "Категория", subtitle: selectedCategory?.header)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addCategoryViewController = CategoryViewController()
        addCategoryViewController.viewModel.$selectedCategory.bind { [weak self] category in
            self?.selectedCategory = category
            self?.buttonTableView.reloadData()
        }
        buttonTableView.deselectRow(at: indexPath, animated: true)
        present(addCategoryViewController, animated: true, completion: nil)
    }
}

extension NewEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        createButton.isEnabled = !updatedText.isEmpty
        return true
    }
}



