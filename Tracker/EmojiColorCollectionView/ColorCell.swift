import UIKit

// MARK: - ColorCell Class

final class ColorCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "color"
    
    private lazy var colorRectangle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Methods
    
    private func addColorRectangle() {
        contentView.addSubview(colorRectangle)
        
        NSLayoutConstraint.activate([
            colorRectangle.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            colorRectangle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            colorRectangle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            colorRectangle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6)
        ])
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        addColorRectangle()
        colorRectangle.backgroundColor = color
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = color.withAlphaComponent(0.3).cgColor
        } else {
            layer.borderWidth = 0
        }
    }
}
