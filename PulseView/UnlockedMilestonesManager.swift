import Foundation

class UnlockedMilestonesManager: ObservableObject {
    static let shared = UnlockedMilestonesManager()
    private let storageKey = "unlockedMilestones"

    @Published var unlockedIDs: Set<String> = []

    private init() {
        load()
    }

    /// Mark a milestone as unlocked
    func unlock(id: String) {
        guard !unlockedIDs.contains(id) else { return }
        unlockedIDs.insert(id)
        save()
        print("✅ Milestone unlocked: \(id)")
    }

    /// Check if a milestone is unlocked
    func isUnlocked(id: String) -> Bool {
        unlockedIDs.contains(id)
    }

    /// Clear all unlocked milestones (for debugging or reset)
    func reset() {
        unlockedIDs.removeAll()
        save()
    }

    private func save() {
        let array = Array(unlockedIDs)
        UserDefaults.standard.set(array, forKey: storageKey)
    }

    private func load() {
        if let array = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            unlockedIDs = Set(array)
        }
    }
}
