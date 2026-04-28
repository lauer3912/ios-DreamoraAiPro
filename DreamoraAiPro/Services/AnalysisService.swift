import Foundation

class AnalysisService {
    static let shared = AnalysisService()

    private init() {}

    func analyzeDream(_ dream: DreamEntry, completion: @escaping (AnalysisResult) -> Void) {
        // Simulate AI analysis with mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let result = self.generateMockAnalysis(for: dream)
            completion(result)
        }
    }

    private func generateMockAnalysis(for dream: DreamEntry) -> AnalysisResult {
        // Generate mock analysis based on dream content
        let emotions: [EmotionItem] = [
            EmotionItem(emotion: "Calm", percentage: 45, color: "MoodPeaceful"),
            EmotionItem(emotion: "Curiosity", percentage: 30, color: "AccentPrimary"),
            EmotionItem(emotion: "Wonder", percentage: 25, color: "AccentSecondary")
        ]

        let symbols = extractSymbols(from: dream.content)
        let themes = extractThemes(from: dream.content)
        let insight = generateInsight(dream: dream)

        return AnalysisResult(
            dreamId: dream.id,
            emotionBreakdown: emotions,
            topSymbols: symbols,
            themeTags: themes,
            psychologyInsight: insight,
            aiConfidence: Double.random(in: 0.75...0.95),
            analyzedAt: Date()
        )
    }

    private func extractSymbols(from content: String) -> [DreamSymbol] {
        let symbolKeywords: [String: (String, String)] = [
            "flying": ("Flying", "Desire for freedom and transcendence"),
            "water": ("Water", "Emotions and transformation"),
            "mountain": ("Mountain", "Challenges and spiritual growth"),
            "falling": ("Falling", "Loss of control or fear of failure"),
            "chase": ("Chase", "Anxiety about being caught or judged"),
            "house": ("House", "The self and different aspects of personality"),
            "animal": ("Animal", "Instincts and natural wisdom"),
            "death": ("Death", "End of a phase and rebirth"),
            "baby": ("Baby", "New beginnings and potential"),
            "train": ("Train", "Life path and direction")
        ]

        var found: [DreamSymbol] = []
        let lowercased = content.lowercased()

        for (keyword, info) in symbolKeywords {
            if lowercased.contains(keyword) {
                found.append(DreamSymbol(symbol: info.0, meaning: info.1, category: "Common"))
            }
        }

        if found.isEmpty {
            found = [
                DreamSymbol(symbol: "Dreamscape", meaning: "The unconscious mind creating symbolic landscapes", category: "General"),
                DreamSymbol(symbol: "Journey", meaning: "Life transitions and personal growth", category: "General")
            ]
        }

        return Array(found.prefix(3))
    }

    private func extractThemes(from content: String) -> [String] {
        let themes = ["self-discovery", "freedom", "transcendence", "anxiety", "creativity", "relationships", "personal-growth", "stress", "hope"]

        var found: [String] = []
        let lowercased = content.lowercased()

        for theme in themes {
            if lowercased.contains(theme) {
                found.append("#\(theme)")
            }
        }

        if found.count < 3 {
            found.append(contentsOf: ["#mystery", "#inner-world"])
        }

        return Array(found.prefix(5))
    }

    private func generateInsight(dream: DreamEntry) -> String {
        let insights = [
            "Dreams about flying often represent a desire to escape limitations and rise above challenges. Your mind may be processing feelings of freedom or conversely, vulnerability.",
            "Recurring dreams about water typically symbolize emotional processing. Your subconscious may be working through complex feelings or life transitions.",
            "Dreams involving mountains often reflect your perception of challenges in waking life. Conquering a mountain in a dream can represent overcoming obstacles.",
            "Chase dreams are common during periods of stress or anxiety. Your mind may be processing threats or responsibilities that feel overwhelming.",
            "Dreams about houses often represent different aspects of yourself. The rooms may symbolize various parts of your psyche or different roles you play."
        ]

        return insights.randomElement() ?? insights[0]
    }
}