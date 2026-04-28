import Foundation

class DatabaseService {
    static let shared = DatabaseService()

    private let dreamsKey = "dreamora_dreams"
    private let userDefaults = UserDefaults.standard

    private init() {}

    func insertDream(_ dream: DreamEntry) {
        var dreams = fetchAllDreams()
        dreams.insert(dream, at: 0)
        saveDreams(dreams)
    }

    func fetchAllDreams() -> [DreamEntry] {
        guard let data = userDefaults.data(forKey: dreamsKey) else {
            return []
        }
        do {
            let dreams = try JSONDecoder().decode([DreamEntry].self, from: data)
            return dreams.sorted { $0.createdAt > $1.createdAt }
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }

    func updateDream(_ dream: DreamEntry) {
        var dreams = fetchAllDreams()
        if let index = dreams.firstIndex(where: { $0.id == dream.id }) {
            dreams[index] = dream
            saveDreams(dreams)
        }
    }

    func deleteDream(_ dream: DreamEntry) {
        var dreams = fetchAllDreams()
        dreams.removeAll { $0.id == dream.id }
        saveDreams(dreams)
    }

    private func saveDreams(_ dreams: [DreamEntry]) {
        do {
            let data = try JSONEncoder().encode(dreams)
            userDefaults.set(data, forKey: dreamsKey)
        } catch {
            print("Save failed: \(error)")
        }
    }
}