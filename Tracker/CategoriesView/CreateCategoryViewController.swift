import UIKit

protocol CategoryAddition {
    func appendCategory(category: String)
    func reload()
}

final class CreateCategoryViewController: UIViewController {
    
    var categoryViewController: CategoryAddition?
    
    
    private let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "Новая категория"
        header.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        header.textColor = .ypBlack
        return header
    }()
    
   
    private let addCategoryName: UITextField = {
        let addCategoryName = UITextField()
        addCategoryName.translatesAutoresizingMaskIntoConstraints = false
        addCategoryName.placeholder = "Введите название категории"
        addCategoryName.backgroundColor = .ypBackground
        addCategoryName.layer.cornerRadius = 16
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        addCategoryName.leftView = leftView
        addCategoryName.leftViewMode = .always
        addCategoryName.keyboardType = .default
        addCategoryName.returnKeyType = .done
        addCategoryName.becomeFirstResponder()
        return addCategoryName
    }()
    
   
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.ypWhite, for: .normal)
        doneButton.backgroundColor = .ypGray
        doneButton.layer.cornerRadius = 16
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.isEnabled = false
        return doneButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCategoryName.delegate = self
        view.backgroundColor = .ypWhite
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(header)
        view.addSubview(addCategoryName)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCategoryName.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 38),
            addCategoryName.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            addCategoryName.heightAnchor.constraint(equalToConstant: 75),
            addCategoryName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addCategoryName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneButtonTapped() {
        guard let category = addCategoryName.text, !category.isEmpty else {
            return
        }
        categoryViewController?.appendCategory(category: category)
        categoryViewController?.reload()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Delegate

extension CreateCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty ?? false {
            doneButton.isEnabled = false
            doneButton.backgroundColor = .ypGray
        } else {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .ypBlack
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

