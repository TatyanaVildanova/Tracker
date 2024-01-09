import UIKit
import CoreData

final class CategoryViewModel {
    
    static let shared = CategoryViewModel()
    private var categoryStore = TrackerCategoryStore.shared
    private (set) var categories: [TrackerCategory] = []
    
    @Observable
    private (set) var selectedCategory: TrackerCategory?
    
    init() {
        categoryStore.delegate = self
        self.categories = categoryStore.trackerCategories
    }
    
    func addCategory(_ toAdd: String) {
        do {
            try
            self.categoryStore.addNewCategory(TrackerCategory(header: toAdd, trackers: []))
        } catch {
            print("Произошла ошибка при добавлении категории: \(error)")
        }
    }
    
    func updateCategory(category: TrackerCategory?, header: String) {
        try! self.categoryStore.updateCategory(category: category, header: header)
    }
    
    func addTrackerToCategory(to category: TrackerCategory?, tracker: Tracker) {
        try! self.categoryStore.addTrackerToCategory(to: category, tracker: tracker)
    }
    
    func selectCategory(at index: Int) {
        self.selectedCategory = self.categories[index]
    }
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func storeCategory() {
        self.categories = categoryStore.trackerCategories
    }
}

