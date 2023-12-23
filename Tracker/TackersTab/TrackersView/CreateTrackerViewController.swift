
import UIKit

// MARK: - Create Tracker ViewController Class

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var regularTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .standardButton, for: "Привычка")
        button.addTarget(self, action: #selector(regularTrackerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .standardButton, for: "Нерегулярное событие")
        button.addTarget(self, action: #selector(irregularTrackerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.TrackerColor.white
        
        addTopNavigationLabel()
        addRegularTrackerButton()
        addIrregularTrackerButton()
    }
    
    // MARK: - Objective-C methods
    
    @objc private func regularTrackerButtonTapped() {
        let regularTrackerViewController = RegularTrackerViewController()
        regularTrackerViewController.delegate = delegate
        
        let navigationController = UINavigationController(rootViewController: regularTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func irregularTrackerButtonTapped() {
        let irregularTrackerViewController = IrregularTrackerViewController()
        irregularTrackerViewController.delegate = delegate
        
        let navigationController = UINavigationController(rootViewController: irregularTrackerViewController)
        present(navigationController, animated: true)
    }
}

// MARK: - Add Subviews

private extension CreateTrackerViewController {
    
    func addTopNavigationLabel() {
        title = "Создание трекера"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.TrackerFont.medium16,
            .foregroundColor: UIColor.TrackerColor.black
        ]
    }
    
    func addRegularTrackerButton() {
        view.addSubview(regularTrackerButton)
        
        NSLayoutConstraint.activate([
            regularTrackerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            regularTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            regularTrackerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func addIrregularTrackerButton() {
        view.addSubview(irregularTrackerButton)
        
        NSLayoutConstraint.activate([
            irregularTrackerButton.topAnchor.constraint(equalTo: regularTrackerButton.bottomAnchor, constant: 16),
            irregularTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularTrackerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}
