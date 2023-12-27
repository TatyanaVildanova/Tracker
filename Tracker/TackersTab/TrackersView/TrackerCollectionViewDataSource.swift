
import UIKit

// MARK: - Tracker CollectionViewDataSource Class

final class TrackerCollectionViewDataSource: NSObject & UICollectionViewDataSource {
    
    // MARK: - Properties
    
    private weak var viewController: TrackersViewController?
    
    // MARK: - Initializers
    
    init(viewController: TrackersViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewController?.getVisibleCategories().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = viewController?.getVisibleCategories()[section].trackers
        return trackers?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cellData = viewController?.getVisibleCategories()
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        
        guard
            let tracker = cellData?[indexPath.section].trackers[indexPath.row],
            let trackerCell = cell as? TrackerCollectionViewCell,
            let isCompletedToday = viewController?.isTrackerCompletedToday(id: tracker.id),
            let completedDays = viewController?.getCompletedTrackers().filter ({
                $0.trackerId == tracker.id
            }).count
        else {
            return UICollectionViewCell()
        }
        
        trackerCell.delegate = viewController
        trackerCell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            at: indexPath
        )
        
        return trackerCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let headerData = viewController?.getVisibleCategories()
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerCollectionViewSectionHeader.reuseIdentifier,
            for: indexPath
        )
        
        guard
            let headerView = view as? TrackerCollectionViewSectionHeader,
            let categoryTitle = headerData?[indexPath.section].title
        else {
            return UICollectionReusableView()
        }
        
        headerView.configure(from: categoryTitle)
        
        return headerView
    }
}
