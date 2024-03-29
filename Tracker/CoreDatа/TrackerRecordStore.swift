
import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func storeRecordsDidUpdate(_ store: TrackerRecordStore)
}

final class TrackerRecordStore: NSObject {
    
    static let shared = TrackerRecordStore()
    
    private var context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    var trackerRecords: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let records = try? objects.map({ try self.record(from: $0)})
        else { return [] }
        return records
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetch = TrackerRecordCoreData.fetchRequest()
        fetch.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true)
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
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = trackerRecord.trackerId
        trackerRecordCoreData.date = trackerRecord.date
        try context.save()
    }
    
    func removeTrackerRecord(_ trackerRecord: TrackerRecord?) throws {
        guard let toDelete = try self.fetchTrackerRecord(with: trackerRecord)
        else { fatalError() }
        context.delete(toDelete)
        try context.save()
    }
    
    func record(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.id,
              let date = trackerRecordCoreData.date
        else { fatalError() }
        return TrackerRecord(trackerId: id, date: date)
    }
    
    func fetchTrackerRecord(with trackerRecord: TrackerRecord?) throws -> TrackerRecordCoreData? {
        guard let trackerRecord = trackerRecord else { fatalError() }
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerRecord.trackerId as CVarArg, trackerRecord.date as NSDate)
        let result = try context.fetch(fetchRequest)
        return result.first
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeRecordsDidUpdate(self)
    }
}

