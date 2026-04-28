import Foundation

struct DreamEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var content: String
    var audioURL: String?
    var mood: Mood
    var dreamType: DreamType
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
    var isFavorite: Bool
    var analysisResult: AnalysisResult?

    init(id: UUID = UUID(),
         title: String,
         content: String,
         audioURL: String? = nil,
         mood: Mood = .neutral,
         dreamType: DreamType = .normal,
         tags: [String] = [],
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         isFavorite: Bool = false,
         analysisResult: AnalysisResult? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.audioURL = audioURL
        self.mood = mood
        self.dreamType = dreamType
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isFavorite = isFavorite
        self.analysisResult = analysisResult
    }

    static let sample = DreamEntry(
        title: "Flying over mountains",
        content: "I was flying over a vast mountain range at sunrise. The peaks were covered in snow and golden light. I felt completely free and peaceful.",
        mood: .peaceful,
        dreamType: .lucid,
        tags: ["flying", "nature", "mountains", "freedom"]
    )
}

enum Mood: String, Codable, CaseIterable {
    case peaceful
    case anxious
    case excited
    case neutral
    case sad

    var emoji: String {
        switch self {
        case .peaceful: return "😌"
        case .anxious: return "😰"
        case .excited: return "🤩"
        case .neutral: return "😐"
        case .sad: return "😢"
        }
    }

    var color: String {
        switch self {
        case .peaceful: return "MoodPeaceful"
        case .anxious: return "MoodAnxious"
        case .excited: return "MoodExcited"
        case .neutral: return "MoodNeutral"
        case .sad: return "MoodSad"
        }
    }
}

enum DreamType: String, Codable, CaseIterable {
    case normal
    case lucid
    case nightmare
    case recurring

    var displayName: String {
        rawValue.capitalized
    }

    var icon: String {
        switch self {
        case .normal: return "moon.fill"
        case .lucid: return "sparkles"
        case .nightmare: return "exclamationmark.triangle.fill"
        case .recurring: return "arrow.triangle.2.circlepath"
        }
    }
}