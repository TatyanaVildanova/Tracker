// MARK: ЯЧЕЙКА ДЛЯ КОЛЛЕКЦИИ ВЫБОРА ЭМОДЗИ

import UIKit

final class EmojiCell: UICollectionViewCell {
    var emojiLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        
        emojiLabel = UILabel(frame: contentView.bounds)
        
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        contentView.addSubview(emojiLabel)
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.ypLightGray : UIColor.clear
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

