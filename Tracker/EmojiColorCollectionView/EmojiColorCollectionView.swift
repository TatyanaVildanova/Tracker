
import UIKit

// MARK: - CollectionView Class

final class EmojiColorCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    private let emojies: [TrackerEmoji] = TrackerEmoji.allCases
    private let colors: [UIColor] = UIColor.TrackerColor.colorSelections()
    private let headers: [String] = ["Emoji", "Цвет"]
    private let params = GeometricParams(
        cellCount: 6,
        leftInset: 18,
        rightInset: 19,
        cellSpacing: 5
    )
    
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    
    weak var selectionDelegate: UpdateTrackerInformationDelegate?
    
    // MARK: - Initializers
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .clear
        
        dataSource = self
        delegate = self
        
        register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
        
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
}

//MARK: - DataSource methods

extension EmojiColorCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        headers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        section == 0 ? emojies.count : colors.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCell.reuseIdentifier,
                for: indexPath
            )
            
            guard let emojiCell = cell as? EmojiCell else {
                return UICollectionViewCell()
            }
            
            let emoji = emojies[indexPath.row].rawValue
            let isSelected = selectedEmoji == emoji
            emojiCell.configure(with: emoji, isSelected: isSelected)
            
            return emojiCell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCell.reuseIdentifier,
                for: indexPath
            )
            
            guard let colorCell = cell as? ColorCell else {
                return UICollectionViewCell()
            }
            
            let color = colors[indexPath.row]
            let isSelected = selectedColor == color
            colorCell.configure(with: color, isSelected: isSelected)
            
            return colorCell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeader.reuseIdentifier,
            for: indexPath
        )
        
        guard let headerView = view as? SectionHeader else {
            return UICollectionReusableView()
        }
        
        switch indexPath.section {
        case 0:
            headerView.configure(from: headers[0])
        case 1:
            headerView.configure(from: headers[1])
        default:
            break
        }
        
        return headerView
    }
    
}

// MARK: - Delegate methods

extension EmojiColorCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 24,
            left: params.leftInset,
            bottom: 40,
            right: params.rightInset
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 18)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 0:
            let emoji = emojies[indexPath.row].rawValue
            selectedEmoji = emoji
            selectionDelegate?.updateSelectedEmoji(emoji)
        case 1:
            let color = colors[indexPath.row]
            selectedColor = color
            selectionDelegate?.updateSelectedColor(color)
        default:
            break
        }
        
        collectionView.reloadData()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 0:
            selectedEmoji = nil
        case 1:
            selectedColor = nil
        default:
            break
        }
        
        collectionView.reloadData()
    }
}
