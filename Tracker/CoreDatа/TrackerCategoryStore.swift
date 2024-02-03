import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeCategoriesDidUpdate(_ store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {
    private var context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private let trackerStore = TrackerStore()
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var trackerCategories: [TrackerCategory] {
        try? fetchedResultsController.performFetch()
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.trackerCategory(from: $0)})
        else { return [] }
        return categories
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetch = TrackerCategoryCoreData.fetchRequest()
        fetch.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.header, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    func addNewCategory(_ category: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.header = category.header
        trackerCategoryCoreData.trackers = category.trackers.map {
            $0.id
        }
        try context.save()
    }
    
    func addTrackerToCategory(to category: TrackerCategory?, tracker: Tracker) throws {
        let category = try? fetchTrackerCategory(with: category)
        var categoryTrackers = category?.trackers ?? []
        categoryTrackers.append(tracker.id)
        category?.trackers = categoryTrackers
        try context.save()
    }
    
    func moveTracker(to category: TrackerCategory?, tracker: Tracker) throws {
        try fetchedResultsController.performFetch()
        guard let objects = self.fetchedResultsController.fetchedObjects else { return }
        for object in objects {
            let filteredTrackers = object.trackers?.filter { $0 != tracker.id }
            object.trackers = filteredTrackers
        }
        try addTrackerToCategory(to: category, tracker: tracker)
    }
    
    func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let header = trackerCategoryCoreData.header,
              let trackers = trackerCategoryCoreData.trackers
        else {
            fatalError()
        }
        return TrackerCategory(header: header, trackers: trackerStore.trackers.filter { trackers.contains($0.id) })
    }
    
    func fetchTrackerCategory(with category: TrackerCategory?) throws -> TrackerCategoryCoreData? {
        guard let header = category?.header else { fatalError() }
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "header == %@", header as CVarArg)
        let result = try context.fetch(fetchRequest)
        return result.first
    }
    
    func categoryForTracker(_ tracker: Tracker) -> TrackerCategory? {
        trackerCategories.filter { $0.trackers.contains(tracker) }.first
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeCategoriesDidUpdate(self)
    }
}

