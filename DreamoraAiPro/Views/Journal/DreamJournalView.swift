import SwiftUI

struct DreamJournalView: View {
    @StateObject private var viewModel = DreamJournalViewModel()
    @State private var searchText = ""
    @State private var selectedMood: Mood? = nil
    @State private var selectedDreamType: DreamType? = nil
    @State private var showAddDream = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                if viewModel.dreams.isEmpty {
                    EmptyJournalView(onAddDream: { showAddDream = true })
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Filter Chips
                            FilterChipsView(
                                selectedMood: $selectedMood,
                                selectedDreamType: $selectedDreamType
                            )

                            // Dream List
                            LazyVStack(spacing: 12) {
                                ForEach(filteredDreams) { dream in
                                    NavigationLink(destination: DreamDetailView(dream: dream)) {
                                        DreamListCard(dream: dream)
                                    }
                                    .contextMenu {
                                        Button(action: { viewModel.toggleFavorite(dream) }) {
                                            Label(dream.isFavorite ? "Unfavorite" : "Favorite",
                                                  systemImage: dream.isFavorite ? "star.slash" : "star.fill")
                                        }
                                        Button(role: .destructive, action: { viewModel.deleteDream(dream) }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
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
            .navigationTitle("Dream Journal")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search dreams...")
            .toolBarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showAddDream) {
                AddDreamView()
            }
            .onAppear {
                viewModel.loadDreams()
            }
        }
    }

    var filteredDreams: [DreamEntry] {
        var result = viewModel.dreams

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        if let mood = selectedMood {
            result = result.filter { $0.mood == mood }
        }

        if let dreamType = selectedDreamType {
            result = result.filter { $0.dreamType == dreamType }
        }

        return result
    }
}

struct FilterChipsView: View {
    @Binding var selectedMood: Mood?
    @Binding var selectedDreamType: DreamType?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Mood filters
                ForEach(Mood.allCases, id: \.self) { mood in
                    FilterChip(
                        title: mood.emoji,
                        isSelected: selectedMood == mood,
                        action: {
                            selectedMood = selectedMood == mood ? nil : mood
                        }
                    )
                }

                Divider()
                    .frame(height: 24)

                // Dream type filters
                ForEach(DreamType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.displayName,
                        isSelected: selectedDreamType == type,
                        action: {
                            selectedDreamType = selectedDreamType == type ? nil : type
                        }
                    )
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentPrimary : Color.surface)
                .foregroundColor(isSelected ? .white : .textSecondary)
                .cornerRadius(16)
        }
    }
}

struct DreamListCard: View {
    let dream: DreamEntry

    var body: some View {
        HStack(spacing: 12) {
            // Mood indicator
            Circle()
                .fill(moodColor)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(dream.title)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)

                    if dream.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.warning)
                    }
                }

                Text(dream.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.textSecondary)

                HStack(spacing: 4) {
                    Image(systemName: dream.dreamType.icon)
                        .font(.caption2)
                    Text(dream.dreamType.displayName)
                        .font(.caption2)
                    Text("·")
                    Text(dream.mood.emoji)
                        .font(.caption2)
                }
                .foregroundColor(.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(12)
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

struct EmptyJournalView: View {
    let onAddDream: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)

            VStack(spacing: 8) {
                Text("Your Dream Journal is Empty")
                    .font(.title2.bold())
                    .foregroundColor(.textPrimary)

                Text("Start recording your dreams to discover patterns and insights")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: onAddDream) {
                Label("Record Your First Dream", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(AppGradient.accentDiagonal)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}

class DreamJournalViewModel: ObservableObject {
    @Published var dreams: [DreamEntry] = []

    private let databaseService = DatabaseService.shared

    func loadDreams() {
        dreams = databaseService.fetchAllDreams().sorted { $0.createdAt > $1.createdAt }
    }

    func deleteDream(_ dream: DreamEntry) {
        databaseService.deleteDream(dream)
        loadDreams()
    }

    func toggleFavorite(_ dream: DreamEntry) {
        var updated = dream
        updated.isFavorite.toggle()
        databaseService.updateDream(updated)
        loadDreams()
    }
}