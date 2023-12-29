import CoreData

// MARK: - Error enumeration

private enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTrackers
    case failedToInitializeTracker
    case failedToFetchCategory
}

// MARK: - TrackerStoreUpdate structure

struct TrackerCategoryStoreUpdate {
    let insertedIndexPaths: [IndexPath]
    let deletedIndexPaths: [IndexPath]
}

// MARK: - Protocols

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerCategoryStoreUpdate)
}

protocol TrackerCategoryStoreProtocol {
    func setDelegate(_ delegate: TrackerCategoryStoreDelegate)
    func getCategories() throws -> [TrackerCategory]
    func fetchCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData
    func addCategory(_ category: TrackerCategory) throws
}

// MARK: - TrackerCategoryStore class

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Properties
    
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    
    private var insertedIndexPaths: [IndexPath] = []
    private var deletedIndexPaths: [IndexPath] = []
    
    private lazy var trackerStore: TrackerStore = {
        TrackerStore(context: context)
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let categoryDescriptor = NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        
        request.sortDescriptors = [categoryDescriptor]
        
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
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
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

private extension TrackerCategoryStore {
    
    func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
    
    func getTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        
        guard let trackersSet = trackerCategoryCoreData.trackers as? Set<TrackerCoreData> else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        
        let trackerList = try trackersSet.compactMap { trackerCoreData in
            guard let tracker = try? trackerStore.getTracker(trackerCoreData) else {
                throw TrackerCategoryStoreError.failedToInitializeTracker
            }
            
            return tracker
        }
        
        return TrackerCategory(title: title, trackers: trackerList)
    }
    
    func fetchCategories() throws -> [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            throw TrackerCategoryStoreError.failedToFetchCategory
        }
        
        let categories = try objects.map { try getTrackerCategory(from: $0) }
        return categories
    }
    
    func fetchTrackerCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let predicate = NSPredicate(format: "title == %@", category.title)
        
        request.predicate = predicate
        
        guard let categoryCoreData = try context.fetch(request).first else {
            throw TrackerCategoryStoreError.failedToFetchCategory
        }
        
        return categoryCoreData
    }
    
    func checkUniqueCategory(with title: String) throws {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let predicate = NSPredicate(format: "title == %@", title)
        request.predicate = predicate
        
        let count = try context.count(for: request)
        
        guard count == 0 else {
            return
        }
    }
    
    func addNewCategory(_ category: TrackerCategory) throws {
        try checkUniqueCategory(with: category.title)
        
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = category.title
        categoryCoreData.trackers = NSSet()
        try saveContext()
    }
}

// MARK: - Protocol methods

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    
    func setDelegate(_ delegate: TrackerCategoryStoreDelegate) {
        self.delegate = delegate
    }
    
    func getCategories() throws -> [TrackerCategory] {
        try fetchCategories()
    }
    
    func fetchCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData {
        try fetchTrackerCategoryCoreData(for: category)
    }
    
    func addCategory(_ category: TrackerCategory) throws {
        try addNewCategory(category)
    }
}

// MARK: - FetchedResultsController methods

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths.removeAll()
        deletedIndexPaths.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            TrackerCategoryStoreUpdate(
                insertedIndexPaths: insertedIndexPaths,
                deletedIndexPaths: deletedIndexPaths
            )
        )
        
        insertedIndexPaths.removeAll()
        deletedIndexPaths.removeAll()
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
        case .delete:
            if let indexPath {
                deletedIndexPaths.append(indexPath)
            }
        default:
            break
        }
    }
}

