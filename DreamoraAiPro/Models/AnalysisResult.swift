import Foundation

struct AnalysisResult: Codable, Equatable {
    let id: UUID
    let dreamId: UUID
    var emotionBreakdown: [EmotionItem]
    var topSymbols: [DreamSymbol]
    var themeTags: [String]
    var psychologyInsight: String
    var aiConfidence: Double
    var analyzedAt: Date

    init(id: UUID = UUID(),
         dreamId: UUID,
         emotionBreakdown: [EmotionItem] = [],
         topSymbols: [DreamSymbol] = [],
         themeTags: [String] = [],
         psychologyInsight: String = "",
         aiConfidence: Double = 0.0,
         analyzedAt: Date = Date()) {
        self.id = id
        self.dreamId = dreamId
        self.emotionBreakdown = emotionBreakdown
        self.topSymbols = topSymbols
        self.themeTags = themeTags
        self.psychologyInsight = psychologyInsight
        self.aiConfidence = aiConfidence
        self.analyzedAt = analyzedAt
    }

    static let sample = AnalysisResult(
        dreamId: UUID(),
        emotionBreakdown: [
            EmotionItem(emotion: "Calm", percentage: 45, color: "AccentColor"),
            EmotionItem(emotion: "Curiosity", percentage: 30, color: "AccentSecondary"),
            EmotionItem(emotion: "Wonder", percentage: 25, color: "AccentPrimary")
        ],
        topSymbols: [
            DreamSymbol(symbol: "Flying", meaning: "Desire for freedom, transcendence", category: "Action"),
            DreamSymbol(symbol: "Mountains", meaning: "Challenges to overcome, spiritual growth", category: "Nature"),
            DreamSymbol(symbol: "Sunrise", meaning: "New beginnings, hope, awakening", category: "Celestial")
        ],
        themeTags: ["self-discovery", "freedom", "transcendence"],
        psychologyInsight: "Flying dreams often represent a desire to escape limitations or rise above problems. Mountains symbolize the journey toward self-actualization.",
        aiConfidence: 0.87
    )
}

struct EmotionItem: Codable, Equatable, Identifiable {
    var id: String { emotion }
    let emotion: String
    let percentage: Int
    let color: String
}

struct DreamSymbol: Codable, Equatable, Identifiable {
    var id: String { symbol }
    let symbol: String
    let meaning: String
    let category: String
}

struct SleepRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    var sleepScore: Int // 0-100
    var sleepHours: Double
    var dreamCount: Int
    var notes: String?

    init(id: UUID = UUID(),
         date: Date = Date(),
         sleepScore: Int = 0,
         sleepHours: Double = 0.0,
         dreamCount: Int = 0,
         notes: String? = nil) {
        self.id = id
        self.date = date
        self.sleepScore = sleepScore
        self.sleepHours = sleepHours
        self.dreamCount = dreamCount
        self.notes = notes
    }

    static let sample = SleepRecord(
        date: Date(),
        sleepScore: 78,
        sleepHours: 7.5,
        dreamCount: 2
    )
}