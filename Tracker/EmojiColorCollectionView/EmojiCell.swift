import UIKit

// MARK: - EmojiCell Class

final class EmojiCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "emoji"
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.TrackerFont.bold32
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Methods
    
    private func addEmojiLabel() {
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.heightAnchor.constraint(equalToConstant: 38),
            emojiLabel.widthAnchor.constraint(equalToConstant: 34),
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with emoji: String, isSelected: Bool) {
        addEmojiLabel()
        emojiLabel.text = emoji
        
        if isSelected {
            backgroundColor = UIColor.TrackerColor.lightGray
            layer.cornerRadius = 16
            layer.masksToBounds = true
        } else {
            backgroundColor = .clear
        }
    }
}
