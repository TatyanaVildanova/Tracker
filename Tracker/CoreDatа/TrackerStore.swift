import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func storeDidUpdate(_ store: TrackerStore) -> Void
}

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    
    private var context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    
    weak var delegate: TrackerStoreDelegate?
    
    var trackers: [Tracker] {
        try? fetchedResultsController.performFetch()
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0)})
        else { return [] }
        return trackers
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetch = TrackerCoreData.fetchRequest()
        fetch.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
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
    
    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.date = tracker.date
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color.hexString()
        trackerCoreData.schedule = tracker.schedule?.map {
            $0.rawValue
        }
        try context.save()
    }
    
    func updateTracker(_ tracker: Tracker) throws {
        guard let fetchedTracker = try fetchTracker(with: tracker) else {
            return
        }
        fetchedTracker.emoji = tracker.emoji
        fetchedTracker.title = tracker.title
        fetchedTracker.color = tracker.color.hexString()
        fetchedTracker.schedule = tracker.schedule?.map {
            $0.rawValue
        }
        try context.save()
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
              let date = trackerCoreData.date,
              let emoji = trackerCoreData.emoji,
              let title = trackerCoreData.title,
              let color = UIColor.color(from: trackerCoreData.color)
        else {
            fatalError()
        }
        
        return Tracker(
            id: id,
            date: date,
            emoji: emoji,
            title: title,
            color: color,
            isPinned: trackerCoreData.isPinned,
            dayCount: Int(trackerCoreData.dayCount),
            schedule: trackerCoreData.schedule?.compactMap { WeekDay(rawValue: $0) }
        )
    }
    
    func deleteTracker(_ tracker: Tracker?) throws {
        guard let fetchedTracker = try fetchTracker(with: tracker) else { return }
        context.delete(fetchedTracker)
        try context.save()
    }
    
    func pinTracker(_ tracker: Tracker?, isPinned: Bool) throws {
        guard let fetchedTracker = try fetchTracker(with: tracker) else { return }
        fetchedTracker.isPinned = isPinned
        try context.save()
    }
    
    func fetchTracker(with tracker: Tracker?) throws -> TrackerCoreData? {
        guard let tracker = tracker else { fatalError() }
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        let result = try context.fetch(fetchRequest)
        return result.first
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate(self)
    }
}

