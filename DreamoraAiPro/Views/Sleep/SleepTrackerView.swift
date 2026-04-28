import SwiftUI

struct SleepTrackerView: View {
    @StateObject private var viewModel = SleepTrackerViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Weekly Chart
                        WeeklySleepChart(records: viewModel.weeklyRecords)

                        // Stats
                        HStack(spacing: 16) {
                            SleepStatCard(
                                title: "Average",
                                value: "\(viewModel.averageScore)",
                                subtitle: "sleep score",
                                icon: "chart.line.uptrend.xyaxis",
                                color: .accentPrimary
                            )
                            SleepStatCard(
                                title: "Best",
                                value: "\(viewModel.bestNight)",
                                subtitle: "score",
                                icon: "crown.fill",
                                color: .warning
                            )
                            SleepStatCard(
                                title: "Streak",
                                value: "\(viewModel.streak)",
                                subtitle: "days",
                                icon: "flame.fill",
                                color: .error
                            )
                        }

                        // Insights
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Insights")
                                .font(.title2.bold())
                                .foregroundColor(.textPrimary)

                            ForEach(viewModel.insights, id: \.self) { insight in
                                InsightCard(text: insight)
                            }
                        }

                        // Calendar Heatmap
                        SleepCalendarHeatmap(records: viewModel.monthlyRecords)

                        // Manual Sleep Log
                        ManualSleepLogCard()
                    }
                    .padding()
                }
            }
            .navigationTitle("Sleep Tracker")
            .navigationBarTitleDisplayMode(.large)
            
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

struct WeeklySleepChart: View {
    let records: [SleepRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.title2.bold())
                    .foregroundColor(.textPrimary)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: viewModel.trend == .up ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption)
                        .foregroundColor(viewModel.trend == .up ? .success : .error)
                    Text(viewModel.trend == .up ? "Improving" : "Declining")
                        .font(.caption)
                        .foregroundColor(viewModel.trend == .up ? .success : .error)
                }
            }

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(records.enumerated()), id: \.element.id) { index, record in
                    VStack(spacing: 4) {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(barGradient(for: record.sleepScore))
                                .frame(width: 40, height: max(20, CGFloat(record.sleepScore) / 100 * 120))

                            Text("\(record.sleepScore)")
                                .font(.caption2.bold())
                                .foregroundColor(.textPrimary)
                        }

                        Text(record.date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2)
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 160)
            .padding()
            .background(Color.surface)
            .cornerRadius(16)
        }
    }

    var viewModel: SleepTrendViewModel {
        var trend: SleepTrend = .stable
        if records.count >= 2 {
            let recentAvg = (records[records.count - 1].sleepScore + records[records.count - 2].sleepScore) / 2
            let olderAvg = (records[0].sleepScore + records[1].sleepScore) / 2
            if recentAvg > olderAvg + 5 { trend = .up }
            else if recentAvg < olderAvg - 5 { trend = .down }
        }
        return SleepTrendViewModel(trend: trend)
    }

    func barGradient(for score: Int) -> LinearGradient {
        if score >= 75 {
            return LinearGradient(colors: [.success], startPoint: .bottom, endPoint: .top)
        } else if score >= 50 {
            return LinearGradient(colors: [.warning], startPoint: .bottom, endPoint: .top)
        } else {
            return LinearGradient(colors: [.error], startPoint: .bottom, endPoint: .top)
        }
    }
}

enum SleepTrend {
    case up, down, stable
}

struct SleepTrendViewModel {
    let trend: SleepTrend
}

struct SleepStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title.bold())
                .foregroundColor(.textPrimary)

            VStack(spacing: 2) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(.textSecondary)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.surface)
        .cornerRadius(16)
    }
}

struct InsightCard: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.warning)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.textPrimary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .cornerRadius(12)
    }
}

struct SleepCalendarHeatmap: View {
    let records: [SleepRecord]

    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Overview")
                .font(.title2.bold())
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(records) { record in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(heatmapColor(for: record.sleepScore))
                        .frame(height: 36)
                }
            }
            .padding()
            .background(Color.surface)
            .cornerRadius(16)

            // Legend
            HStack(spacing: 16) {
                Text("Less")
                    .font(.caption2)
                    .foregroundColor(.textSecondary)

                HStack(spacing: 4) {
                    ForEach([0, 25, 50, 75, 100], id: \.self) { value in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(heatmapColor(for: value))
                            .frame(width: 16, height: 16)
                    }
                }

                Text("More")
                    .font(.caption2)
                    .foregroundColor(.textSecondary)
            }
        }
    }

    func heatmapColor(for score: Int) -> Color {
        if score == 0 { return Color.surface }
        if score < 25 { return Color.error.opacity(0.3) }
        if score < 50 { return Color.error.opacity(0.6) }
        if score < 75 { return Color.warning.opacity(0.6) }
        return Color.success.opacity(0.8)
    }
}

struct ManualSleepLogCard: View {
    @State private var sleepTime = Date()
    @State private var wakeTime = Date()
    @State private var showSaveConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Log Sleep Manually")
                .font(.title2.bold())
                .foregroundColor(.textPrimary)

            VStack(spacing: 16) {
                DatePicker("Bedtime", selection: $sleepTime, displayedComponents: .hourAndMinute)
                    .foregroundColor(.textPrimary)

                DatePicker("Wake Time", selection: $wakeTime, displayedComponents: .hourAndMinute)
                    .foregroundColor(.textPrimary)

                Button(action: { showSaveConfirmation = true }) {
                    Text("Save Sleep Log")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppGradient.accentDiagonal)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(Color.surface)
            .cornerRadius(16)
            .alert("Sleep Logged", isPresented: $showSaveConfirmation) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your sleep has been recorded.")
            }
        }
    }
}

class SleepTrackerViewModel: ObservableObject {
    @Published var weeklyRecords: [SleepRecord] = []
    @Published var monthlyRecords: [SleepRecord] = []
    @Published var averageScore: Int = 0
    @Published var bestNight: Int = 0
    @Published var streak: Int = 0
    @Published var insights: [String] = []

    func loadData() {
        weeklyRecords = (0..<7).map { dayOffset in
            let date = Calendar.current.date(byAdding: .day, value: -6 + dayOffset, to: Date()) ?? Date()
            return SleepRecord(date: date, sleepScore: Int.random(in: 55...95), sleepHours: Double.random(in: 5...9), dreamCount: Int.random(in: 0...3))
        }

        monthlyRecords = (0..<28).map { dayOffset in
            let date = Calendar.current.date(byAdding: .day, value: -27 + dayOffset, to: Date()) ?? Date()
            return SleepRecord(date: date, sleepScore: Int.random(in: 50...95))
        }

        averageScore = weeklyRecords.reduce(0) { $0 + $1.sleepScore } / weeklyRecords.count
        bestNight = weeklyRecords.map { $0.sleepScore }.max() ?? 0
        streak = 12

        insights = [
            "Your sleep quality improves on days you record dreams.",
            "Try to maintain a consistent bedtime for better scores.",
            "You've hit your 7-day streak! Keep it up!"
        ]
    }
}