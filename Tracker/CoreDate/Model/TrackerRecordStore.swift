import CoreData

// MARK: - Error enumeration

private enum TrackerRecordStoreError: Error {
    case failedToFetchTracker
    case failedToFetchRecord
}

// MARK: - Protocols

protocol TrackerRecordStoreProtocol {
    func fetchRecords(for tracker: Tracker) throws -> [TrackerRecord]
    func addRecord(with id: UUID, by date: Date) throws
    func deleteRecord(with id: UUID, by date: Date) throws
}

// MARK: - TrackerRecordStore class

final class TrackerRecordStore: NSObject {
    
    // MARK: - Properties
    
    private let context: NSManagedObjectContext
    
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

private extension TrackerRecordStore {
    
    func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
    
    func fetchRecords(_ tracker: Tracker) throws -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let predicate = NSPredicate(format: "tracker.trackerId = %@", tracker.id as CVarArg)
        request.predicate = predicate
        
        guard let objects = try? context.fetch(request) else {
            return []
        }
        
        let records = objects.compactMap { object -> TrackerRecord? in
            guard let date = object.date, let id = object.trackerId else { return nil }
            return TrackerRecord(trackerId: id, date: date)
        }
        
        return records
    }
    
    func fetchTrackerCoreData(for trackerId: UUID) throws -> TrackerCoreData? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerId), trackerId as CVarArg
        )
        
        request.predicate = predicate
        
        guard let trackerCoreData = try context.fetch(request).first else {
            throw TrackerRecordStoreError.failedToFetchTracker
        }
        
        return trackerCoreData
    }

    func addRecord(id: UUID, date: Date) throws {
        guard let trackerCoreData = try fetchTrackerCoreData(for: id) else {
            throw TrackerRecordStoreError.failedToFetchTracker
        }

        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerId = id
        trackerRecordCoreData.date = date
        trackerRecordCoreData.tracker = trackerCoreData

        try saveContext()
    }
    
    func fetchTrackerRecordCoreData(for recordId: UUID, and date: Date) throws -> TrackerRecordCoreData? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            #keyPath(TrackerRecordCoreData.tracker.trackerId), recordId as CVarArg,
            #keyPath(TrackerRecordCoreData.date), date as CVarArg
        )
        
        request.predicate = predicate
        
        guard let recordCoreData = try context.fetch(request).first else {
            throw TrackerRecordStoreError.failedToFetchRecord
        }
        
        return recordCoreData
    }
    
    func deleteRecord(id: UUID, date: Date) throws {
        guard let recordCoreData = try fetchTrackerRecordCoreData(for: id, and: date) else {
            throw TrackerRecordStoreError.failedToFetchRecord
        }
        
        context.delete(recordCoreData)
        try saveContext()
    }
}

// MARK: - Protocol methods

extension TrackerRecordStore: TrackerRecordStoreProtocol {
    
    func fetchRecords(for tracker: Tracker) throws -> [TrackerRecord] {
        try fetchRecords(tracker)
    }
    
    func addRecord(with id: UUID, by date: Date) throws {
        try addRecord(id: id, date: date)
    }
    
    func deleteRecord(with id: UUID, by date: Date) throws {
        try deleteRecord(id: id, date: date)
    }
}

