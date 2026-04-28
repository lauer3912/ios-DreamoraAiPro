import SwiftUI

struct DreamCard: View {
    let dream: DreamEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(dream.title)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                Spacer()

                if dream.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.warning)
                }
            }

            Text(dream.content)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .lineLimit(2)

            HStack(spacing: 8) {
                // Mood
                HStack(spacing: 4) {
                    Text(dream.mood.emoji)
                    Text(dream.mood.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                Text("·")
                    .foregroundColor(.textSecondary)

                // Dream type
                HStack(spacing: 4) {
                    Image(systemName: dream.dreamType.icon)
                        .font(.caption2)
                    Text(dream.dreamType.displayName)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                // Date
                Text(dream.createdAt.formatted(.dateTime.month(.abbreviated).day()))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            // Tags preview
            if !dream.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(dream.tags.prefix(3), id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption2)
                                .foregroundColor(.accentPrimary.opacity(0.8))
                        }
                        if dream.tags.count > 3 {
                            Text("+\(dream.tags.count - 3)")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(moodColor.opacity(0.3), lineWidth: 1)
        )
    }

    var moodColor: Color {
        switch dream.mood {
        case .peaceful: return .moodPeaceful
        case .anxious: return .moodAnxious
        case .excited: return .moodExcited
        case .neutral: return .moodNeutral
        case .sad: return .moodSad
        }
    }
}

struct MoodRing: View {
    let score: Int
    let size: CGFloat

    @State private var animatedScore: Int = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.surface, lineWidth: size / 10)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: CGFloat(animatedScore) / 100)
                .stroke(
                    AppGradient.accentDiagonal,
                    style: StrokeStyle(lineWidth: size / 10, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text("\(animatedScore)")
                    .font(.system(size: size / 3, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                Text("mood")
                    .font(.system(size: size / 10))
                    .foregroundColor(.textSecondary)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                animatedScore = score
            }
        }
    }
}

struct SleepChart: View {
    let records: [SleepRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sleep Trend")
                .font(.headline)
                .foregroundColor(.textPrimary)

            GeometryReader { geometry in
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(records) { record in
                        VStack(spacing: 4) {
                            Spacer()
                            RoundedRectangle(cornerRadius: 6)
                                .fill(barColor(for: record.sleepScore))
                                .frame(height: barHeight(for: record.sleepScore, maxHeight: geometry.size.height))

                            Text(record.date.formatted(.dateTime.weekday(.narrow)))
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: 140)
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(16)
    }

    func barHeight(for score: Int, maxHeight: CGFloat) -> CGFloat {
        max(20, CGFloat(score) / 100 * maxHeight)
    }

    func barColor(for score: Int) -> LinearGradient {
        if score >= 75 {
            return LinearGradient(colors: [.success], startPoint: .bottom, endPoint: .top)
        } else if score >= 50 {
            return LinearGradient(colors: [.warning], startPoint: .bottom, endPoint: .top)
        } else {
            return LinearGradient(colors: [.error], startPoint: .bottom, endPoint: .top)
        }
    }
}

struct AudioWaveform: View {
    let isRecording: Bool
    let bars: Int

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<bars, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.accentPrimary)
                    .frame(width: 4, height: isRecording ? CGFloat.random(in: 10...40) : 10)
                    .animation(
                        isRecording ? .easeInOut(duration: 0.3).repeatForever().delay(Double(index) * 0.05) : .default,
                        value: isRecording
                    )
            }
        }
        .frame(height: 40)
    }
}

struct AIAnalysisCard: View {
    let analysis: AnalysisResult

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(.accentPrimary)

                VStack(alignment: .leading, spacing: 2) {
                    Text("AI Analysis")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    Text("\(Int(analysis.aiConfidence * 100))% confidence")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            Divider()
                .background(Color.textSecondary.opacity(0.3))

            // Emotions
            VStack(alignment: .leading, spacing: 8) {
                Text("Emotions")
                    .font(.subheadline.bold())
                    .foregroundColor(.textSecondary)

                ForEach(analysis.emotionBreakdown) { emotion in
                    HStack {
                        Text(emotion.emotion)
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)

                        Spacer()

                        Text("\(emotion.percentage)%")
                            .font(.subheadline.bold())
                            .foregroundColor(.accentPrimary)
                    }
                    .padding(.vertical, 2)
                }
            }

            // Symbols
            if !analysis.topSymbols.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Symbols")
                        .font(.subheadline.bold())
                        .foregroundColor(.textSecondary)

                    ForEach(analysis.topSymbols.prefix(2)) { symbol in
                        HStack {
                            Text(symbol.symbol)
                                .font(.subheadline.bold())
                                .foregroundColor(.accentSecondary)
                            Text("- \(symbol.meaning)")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                                .lineLimit(1)
                        }
                    }
                }
            }

            // Insight preview
            Text("\"\(analysis.psychologyInsight.prefix(80))...\")")
                .font(.caption)
                .foregroundColor(.textSecondary)
                .italic()
                .lineLimit(2)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.surface, Color.accentPrimary.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

struct PremiumBadge: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.warning, .accentPrimary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 24, height: 24)
                .shadow(color: .warning.opacity(0.5), radius: 4)

            Image(systemName: "crown.fill")
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}