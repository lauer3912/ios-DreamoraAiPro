import XCTest
@testable import DreamoraAiPro

final class DreamoraAiProTests: XCTestCase {

    func testDreamEntryCreation() {
        let dream = DreamEntry(
            title: "Flying Over Mountains",
            content: "I was flying over snowy mountains at sunrise.",
            mood: .peaceful,
            dreamType: .lucid,
            tags: ["flying", "nature"]
        )

        XCTAssertEqual(dream.title, "Flying Over Mountains")
        XCTAssertEqual(dream.mood, .peaceful)
        XCTAssertEqual(dream.dreamType, .lucid)
        XCTAssertEqual(dream.tags.count, 2)
    }

    func testMoodEmoji() {
        XCTAssertEqual(Mood.peaceful.emoji, "😌")
        XCTAssertEqual(Mood.anxious.emoji, "😰")
        XCTAssertEqual(Mood.excited.emoji, "🤩")
        XCTAssertEqual(Mood.neutral.emoji, "😐")
        XCTAssertEqual(Mood.sad.emoji, "😢")
    }

    func testDreamTypeDisplayName() {
        XCTAssertEqual(DreamType.normal.displayName, "Normal")
        XCTAssertEqual(DreamType.lucid.displayName, "Lucid")
        XCTAssertEqual(DreamType.nightmare.displayName, "Nightmare")
        XCTAssertEqual(DreamType.recurring.displayName, "Recurring")
    }

    func testAnalysisResultSample() {
        let result = AnalysisResult.sample
        XCTAssertEqual(result.emotionBreakdown.count, 3)
        XCTAssertEqual(result.topSymbols.count, 3)
        XCTAssertFalse(result.psychologyInsight.isEmpty)
    }

    func testSleepRecord() {
        let record = SleepRecord(date: Date(), sleepScore: 85, sleepHours: 7.5, dreamCount: 2)
        XCTAssertEqual(record.sleepScore, 85)
        XCTAssertEqual(record.sleepHours, 7.5)
        XCTAssertEqual(record.dreamCount, 2)
    }
}