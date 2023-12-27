
import UIKit

// MARK: - Protocols

protocol CreateCategoryViewControllerDelegate: AnyObject {
    func updateListOfCategories(with category: TrackerCategory)
}

// MARK: - Create Category ViewController Class

final class CreateCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var categoryTitleTextField: UITextField = {
        let textField = UITextField()
        textField.configure(with: "Введите название категории")
        textField.delegate = self
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .standardButton, for: "Готово")
        button.backgroundColor = UIColor.TrackerColor.gray
        button.isEnabled = false
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CreateCategoryViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white
        
        addTopNavigationLabel()
        addCategoryTitleTextField()
        addConfirmButton()
    }
    
    // MARK: - Objective-C methods
    
    @objc private func confirmButtonTapped() {
        if let text = categoryTitleTextField.text, !text.isEmpty {
            let category = TrackerCategory(title: text, trackers: [])
            delegate?.updateListOfCategories(with: category)
        }
        
        dismiss(animated: true)
    }
}

// MARK: - Add Subviews

private extension CreateCategoryViewController {
    
    func addTopNavigationLabel() {
        title = "Новая категория"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.TrackerFont.medium16,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addCategoryTitleTextField() {
        view.addSubview(categoryTitleTextField)
        
        NSLayoutConstraint.activate([
            categoryTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTitleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTitleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func addConfirmButton() {
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - TextFieldDelegate methods

extension CreateCategoryViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let newLength = text.count + string.count - range.length
        
        if newLength >= 1 && newLength <= 38 {
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.TrackerColor.black
        } else {
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = UIColor.TrackerColor.gray
        }
        
        return newLength <= 38
    }
}
