import SwiftUI

struct DreamDetailView: View {
    let dream: DreamEntry
    @EnvironmentObject var appState: AppState
    @State private var showAnalysis = false

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            DreamTypeBadge(type: dream.dreamType)
                            Text(dream.mood.emoji)
                                .font(.title2)
                        }

                        Text(dream.title)
                            .font(.title.bold())
                            .foregroundColor(.textPrimary)

                        Text(dream.createdAt.formatted(date: .long, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }

                    // Content
                    Text(dream.content)
                        .font(.body)
                        .foregroundColor(.textPrimary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.surface)
                        .cornerRadius(12)

                    // Tags
                    if !dream.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(dream.tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.accentPrimary.opacity(0.2))
                                        .foregroundColor(.accentPrimary)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }

                    // Audio Player
                    if let audioURL = dream.audioURL {
                        AudioPlayerView(audioURL: audioURL)
                    }

                    // AI Analysis Section
                    if let analysis = dream.analysisResult {
                        AIAnalysisCard(analysis: analysis)
                            .onTapGesture {
                                showAnalysis = true
                            }
                    } else if appState.isPremium {
                        Button(action: { analyzeDream() }) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                Text("Analyze with AI")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppGradient.accentDiagonal)
                            .cornerRadius(12)
                        }
                    } else {
                        PremiumLockCard(feature: "AI Dream Analysis")
                    }

                    // Favorite Button
                    Button(action: toggleFavorite) {
                        HStack {
                            Image(systemName: dream.isFavorite ? "star.fill" : "star")
                            Text(dream.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        }
                        .font(.subheadline)
                        .foregroundColor(.warning)
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationTitle("Dream Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolBarColorScheme(.dark, for: .navigationBar)
    }

    func analyzeDream() {
        // Mock AI analysis
    }

    func toggleFavorite() {
        // Toggle favorite via view model
    }
}

struct DreamTypeBadge: View {
    let type: DreamType

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: type.icon)
                .font(.caption)
            Text(type.displayName)
                .font(.caption.bold())
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.2))
        .foregroundColor(badgeColor)
        .cornerRadius(8)
    }

    var badgeColor: Color {
        switch type {
        case .normal: return .textSecondary
        case .lucid: return .accentPrimary
        case .nightmare: return .error
        case .recurring: return .accentSecondary
        }
    }
}

struct AudioPlayerView: View {
    let audioURL: String
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: 12) {
            Button(action: { isPlaying.toggle() }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundColor(.accentPrimary)
            }

            // Waveform visualization
            HStack(spacing: 2) {
                ForEach(0..<30, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.accentPrimary.opacity(0.6))
                        .frame(width: 4, height: CGFloat.random(in: 8...24))
                }
            }

            Spacer()

            Text("0:00 / 1:23")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(12)
    }
}

struct AIAnalysisCard: View {
    let analysis: AnalysisResult

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.accentPrimary)
                Text("AI Analysis")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("\(Int(analysis.aiConfidence * 100))% confidence")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            // Emotion breakdown
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
                }
            }

            // Top Symbols
            if !analysis.topSymbols.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Symbols")
                        .font(.subheadline.bold())
                        .foregroundColor(.textSecondary)

                    ForEach(analysis.topSymbols.prefix(3)) { symbol in
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

            Text("Tap to see full analysis →")
                .font(.caption)
                .foregroundColor(.accentPrimary)
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(12)
    }
}

struct PremiumLockCard: View {
    let feature: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .font(.title)
                .foregroundColor(.textSecondary)

            Text("\(feature) is a Premium feature")
                .font(.subheadline)
                .foregroundColor(.textSecondary)

            NavigationLink(destination: PremiumView()) {
                Text("Unlock Premium")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(AppGradient.accentDiagonal)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.surface)
        .cornerRadius(12)
    }
}