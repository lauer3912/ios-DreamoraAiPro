import Foundation
import SQLite

class DatabaseService {
    static let shared = DatabaseService()

    private var db: Connection?

    // Table definitions
    private let dreams = Table("dreams")
    private let id = Expression<String>("id")
    private let title = Expression<String>("title")
    private let content = Expression<String>("content")
    private let audioURL = Expression<String?>("audioURL")
    private let mood = Expression<String>("mood")
    private let dreamType = Expression<String>("dreamType")
    private let tags = Expression<String>("tags")
    private let createdAt = Expression<Double>("createdAt")
    private let updatedAt = Expression<Double>("updatedAt")
    private let isFavorite = Expression<Bool>("isFavorite")
    private let analysisJSON = Expression<String?>("analysisJSON")

    private init() {
        setupDatabase()
    }

    private func setupDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/dreamora.sqlite3")
            createTables()
        } catch {
            print("Database setup failed: \(error)")
        }
    }

    private func createTables() {
        do {
            try db?.run(dreams.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(title)
                t.column(content)
                t.column(audioURL)
                t.column(mood)
                t.column(dreamType)
                t.column(tags)
                t.column(createdAt)
                t.column(updatedAt)
                t.column(isFavorite)
                t.column(analysisJSON)
            })
        } catch {
            print("Table creation failed: \(error)")
        }
    }

    func insertDream(_ dream: DreamEntry) {
        do {
            let tagsJSON = (try? JSONEncoder().encode(dream.tags)).flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
            let analysisJSONString = dream.analysisResult.flatMap { result in
                try? JSONEncoder().encode(result)
            }.flatMap { String(data: $0, encoding: .utf8) }

            try db?.run(dreams.insert(
                id <- dream.id.uuidString,
                title <- dream.title,
                content <- dream.content,
                audioURL <- dream.audioURL,
                mood <- dream.mood.rawValue,
                dreamType <- dream.dreamType.rawValue,
                tags <- tagsJSON,
                createdAt <- dream.createdAt.timeIntervalSince1970,
                updatedAt <- dream.updatedAt.timeIntervalSince1970,
                isFavorite <- dream.isFavorite,
                analysisJSON <- analysisJSONString
            ))
        } catch {
            print("Insert failed: \(error)")
        }
    }

    func fetchAllDreams() -> [DreamEntry] {
        var result: [DreamEntry] = []
        do {
            let query = dreams.order(createdAt.desc)
            for row in try db?.prepare(query) ?? AnySequence([]) {
                if let entry = dreamFromRow(row) {
                    result.append(entry)
                }
            }
        } catch {
            print("Fetch failed: \(error)")
        }
        return result
    }

    func updateDream(_ dream: DreamEntry) {
        do {
            let tagsJSON = (try? JSONEncoder().encode(dream.tags)).flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
            let analysisJSONString = dream.analysisResult.flatMap { result in
                try? JSONEncoder().encode(result)
            }.flatMap { String(data: $0, encoding: .utf8) }

            let target = dreams.filter(id == dream.id.uuidString)
            try db?.run(target.update(
                title <- dream.title,
                content <- dream.content,
                audioURL <- dream.audioURL,
                mood <- dream.mood.rawValue,
                dreamType <- dream.dreamType.rawValue,
                tags <- tagsJSON,
                updatedAt <- Date().timeIntervalSince1970,
                isFavorite <- dream.isFavorite,
                analysisJSON <- analysisJSONString
            ))
        } catch {
            print("Update failed: \(error)")
        }
    }

    func deleteDream(_ dream: DreamEntry) {
        do {
            let target = dreams.filter(id == dream.id.uuidString)
            try db?.run(target.delete())
        } catch {
            print("Delete failed: \(error)")
        }
    }

    private func dreamFromRow(_ row: Row) -> DreamEntry? {
        guard let uuid = UUID(uuidString: row[id]),
              let moodEnum = Mood(rawValue: row[mood]),
              let typeEnum = DreamType(rawValue: row[dreamType]) else {
            return nil
        }

        let tagsArray: [String] = (try? JSONDecoder().decode([String].self, from: Data(row[tags].utf8))) ?? []
        let analysis: AnalysisResult? = row[analysisJSON].flatMap { jsonString in
            try? JSONDecoder().decode(AnalysisResult.self, from: Data(jsonString.utf8))
        }

        return DreamEntry(
            id: uuid,
            title: row[title],
            content: row[content],
            audioURL: row[audioURL],
            mood: moodEnum,
            dreamType: typeEnum,
            tags: tagsArray,
            createdAt: Date(timeIntervalSince1970: row[createdAt]),
            updatedAt: Date(timeIntervalSince1970: row[updatedAt]),
            isFavorite: row[isFavorite],
            analysisResult: analysis
        )
    }
}