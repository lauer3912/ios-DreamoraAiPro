import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showAddDream = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Sleep Score Ring
                        SleepScoreRing(score: viewModel.sleepScore)
                            .frame(height: 200)

                        // Quick Stats
                        QuickStatsView(
                            totalDreams: viewModel.totalDreams,
                            currentStreak: viewModel.streak,
                            avgMood: viewModel.averageMood
                        )

                        // Recent Dreams
                        RecentDreamsSection(dreams: viewModel.recentDreams)

                        // Sleep Chart Preview
                        WeeklySleepPreview(records: viewModel.weeklyRecords)

                        // Tip of the Day
                        TipOfTheDayView(tip: viewModel.tipOfTheDay)
                    }
                    .padding()
                }

                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showAddDream = true }) {
                            ZStack {
                                Circle()
                                    .fill(AppGradient.accentDiagonal)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: .accentPrimary.opacity(0.5), radius: 10)

                                Image(systemName: "plus")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Dreamora")
            .navigationBarTitleDisplayMode(.large)
            .toolBarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showAddDream) {
                AddDreamView()
            }
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

struct SleepScoreRing: View {
    let score: Int
    @State private var animatedScore: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.surface, lineWidth: 12)
                    .frame(width: 160, height: 160)

                Circle()
                    .trim(from: 0, to: CGFloat(animatedScore) / 100)
                    .stroke(
                        AppGradient.accentDiagonal,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text("\(animatedScore)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                    Text("Sleep Score")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedScore = score
            }
        }
    }
}

struct QuickStatsView: View {
    let totalDreams: Int
    let currentStreak: Int
    let avgMood: String

    var body: some View {
        HStack(spacing: 16) {
            StatCard(title: "Dreams", value: "\(totalDreams)", icon: "book.fill", color: .accentPrimary)
            StatCard(title: "Streak", value: "\(currentStreak)d", icon: "flame.fill", color: .warning)
            StatCard(title: "Mood", value: avgMood, icon: "face.smiling", color: .success)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title3.bold())
                .foregroundColor(.textPrimary)
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.surface)
        .cornerRadius(16)
    }
}

struct RecentDreamsSection: View {
    let dreams: [DreamEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Dreams")
                    .font(.title2.bold())
                    .foregroundColor(.textPrimary)
                Spacer()
                NavigationLink(destination: DreamJournalView()) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.accentPrimary)
                }
            }

            if dreams.isEmpty {
                EmptyStateCard(message: "No dreams yet. Tap + to record your first dream!")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(dreams) { dream in
                            NavigationLink(destination: DreamDetailView(dream: dream)) {
                                DreamCard(dream: dream)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct WeeklySleepPreview: View {
    let records: [SleepRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(.title2.bold())
                .foregroundColor(.textPrimary)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(records) { record in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(scoreColor(record.sleepScore))
                            .frame(width: 36, height: CGFloat(record.sleepScore) / 100 * 100)

                        Text(record.date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .frame(height: 120)
            .padding()
            .background(Color.surface)
            .cornerRadius(16)
        }
    }

    func scoreColor(_ score: Int) -> Color {
        if score >= 75 { return .success }
        if score >= 50 { return .warning }
        return .error
    }
}

struct TipOfTheDayView: View {
    let tip: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.title2)
                .foregroundColor(.warning)

            Text(tip)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .cornerRadius(16)
    }
}

struct EmptyStateCard: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "moon.stars")
                .font(.largeTitle)
                .foregroundColor(.textSecondary)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color.surface)
        .cornerRadius(16)
    }
}

class HomeViewModel: ObservableObject {
    @Published var sleepScore: Int = 72
    @Published var totalDreams: Int = 0
    @Published var streak: Int = 0
    @Published var averageMood: String = "😌"
    @Published var recentDreams: [DreamEntry] = []
    @Published var weeklyRecords: [SleepRecord] = []
    @Published var tipOfTheDay: String = "Keep a dream journal by your bed to capture dreams before they fade."

    private let databaseService = DatabaseService.shared

    func loadData() {
        let dreams = databaseService.fetchAllDreams()
        totalDreams = dreams.count
        recentDreams = Array(dreams.prefix(5))
        streak = calculateStreak(dreams: dreams)
        averageMood = calculateAverageMood(dreams: dreams)
        weeklyRecords = generateWeeklyRecords()
    }

    private func calculateStreak(dreams: [DreamEntry]) -> Int {
        // Mock streak calculation
        return 7
    }

    private func calculateAverageMood(dreams: [DreamEntry]) -> String {
        guard !dreams.isEmpty else { return "😌" }
        let moodCounts = Dictionary(grouping: dreams, by: { $0.mood })
        let sorted = moodCounts.sorted { $0.value.count > $1.value.count }
        return sorted.first?.key.emoji ?? "😌"
    }

    private func generateWeeklyRecords() -> [SleepRecord] {
        (0..<7).map { dayOffset in
            let date = Calendar.current.date(byAdding: .day, value: -6 + dayOffset, to: Date()) ?? Date()
            return SleepRecord(date: date, sleepScore: Int.random(in: 60...95), sleepHours: Double.random(in: 5.5...8.5), dreamCount: Int.random(in: 0...3))
        }
    }
}