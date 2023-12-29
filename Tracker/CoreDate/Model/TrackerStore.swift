import CoreData

// MARK: - Error enumeration

private enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidTitle
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedule
}

// MARK: - TrackerStoreUpdate structure

struct TrackerStoreUpdate {
    let insertedSections: IndexSet
    let insertedIndexPaths: [IndexPath]
}

// MARK: - Protocols

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerStoreUpdate)
}

protocol TrackerStoreProtocol {
    func setDelegate(_ delegate: TrackerStoreDelegate)
    func getTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker
    func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws
}

// MARK: - TrackerStore class

final class TrackerStore: NSObject {

    // MARK: - Properties

    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()

    private var insertedSections: IndexSet = []
    private var insertedIndexPaths: [IndexPath] = []
    
    private lazy var trackerCategoryStore: TrackerCategoryStoreProtocol = {
        TrackerCategoryStore(context: context)
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackerDescriptor = NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true)
        let categoryDescriptor = NSSortDescriptor(keyPath: \TrackerCoreData.category?.title, ascending: false)
        
        request.sortDescriptors = [trackerDescriptor, categoryDescriptor]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        try? controller.performFetch()
        return controller
    }()

    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.getTracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    weak var delegate: TrackerStoreDelegate?

    // MARK: - Initializers

    convenience override init() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
}

// MARK: - Private methods

private extension TrackerStore {
    
    func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }

    func getTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.trackerId else {
            throw TrackerStoreError.decodingErrorInvalidId
        }

        guard let title = trackerCoreData.title else {
            throw TrackerStoreError.decodingErrorInvalidTitle
        }

        guard let colorString = trackerCoreData.color else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }

        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }

        guard let scheduleString = trackerCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }

        let color = uiColorMarshalling.getColor(from: colorString)
        let schedule = Weekday.getWeekday(from: scheduleString)
        
        return Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
    }

    func addNewTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
        let trackerCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(for: category)
        let trackerCoreData = TrackerCoreData(context: context)

        trackerCoreData.trackerId = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = uiColorMarshalling.getHexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = Weekday.getString(from: tracker.schedule)
        trackerCoreData.category = trackerCategoryCoreData
        
        try saveContext()
    }
}

// MARK: - Protocol methods

extension TrackerStore: TrackerStoreProtocol {
    
    func setDelegate(_ delegate: TrackerStoreDelegate) {
        self.delegate = delegate
    }
    
    func getTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
        try getTracker(from: trackerCoreData)
    }
    
    func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
        try addNewTracker(tracker, with: category)
    }
}

// MARK: - FetchedResultsController methods

extension TrackerStore: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            TrackerStoreUpdate(
                insertedSections: insertedSections,
                insertedIndexPaths: insertedIndexPaths
            )
        )
        
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexPaths.append(indexPath)
            }
        default:
            break
        }
    }
}
