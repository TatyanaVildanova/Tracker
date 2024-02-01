import UIKit

final class ColorCell: UICollectionViewCell {
    let innerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.clipsToBounds = true
        
        innerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(innerView)
        
        NSLayoutConstraint.activate([
            innerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            innerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            innerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            innerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
        
        innerView.layer.cornerRadius = 8
        innerView.clipsToBounds = true
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? innerView.backgroundColor?.cgColor.copy(alpha: 0.3) : UIColor.clear.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

