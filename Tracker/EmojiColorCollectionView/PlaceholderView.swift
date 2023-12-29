
import UIKit

// MARK: - PlaceholderView Class

final class PlaceholderView: UIView {
    
    // MARK: - Properties
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.TrackerFont.medium12
        label.textColor = UIColor.TrackerColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 200
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    init(image: UIImage, title: String) {
        super.init(frame: .zero)
        
        placeholderImageView.image = image
        placeholderTitleLabel.text = title
        
        addPlaceholderImageView()
        addPlaceholderTitleLabel()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func addPlaceholderImageView() {
        self.addSubview(placeholderImageView)
        
        NSLayoutConstraint.activate([
            placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func addPlaceholderTitleLabel() {
        self.addSubview(placeholderTitleLabel)
        
        NSLayoutConstraint.activate([
            placeholderTitleLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderTitleLabel.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor)
        ])
    }
}
