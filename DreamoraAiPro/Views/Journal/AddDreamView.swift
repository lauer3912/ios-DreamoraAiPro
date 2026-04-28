import SwiftUI

struct AddDreamView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AddDreamViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Title Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dream Title")
                                .font(.subheadline.bold())
                                .foregroundColor(.textSecondary)

                            TextField("Summarize your dream...", text: $viewModel.title)
                                .textFieldStyle(DreamTextFieldStyle())
                        }

                        // Content Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dream Content")
                                .font(.subheadline.bold())
                                .foregroundColor(.textSecondary)

                            TextEditor(text: $viewModel.content)
                                .frame(minHeight: 150)
                                .padding(12)
                                .background(Color.surface)
                                .cornerRadius(12)
                                .foregroundColor(.textPrimary)
                                .scrollContentBackground(.hidden)

                            HStack {
                                Spacer()
                                Text("\(viewModel.content.count) characters")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }

                        // Voice Recording
                        VoiceRecordingView(isRecording: $viewModel.isRecording, duration: $viewModel.recordingDuration)

                        // Mood Selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How did you feel?")
                                .font(.subheadline.bold())
                                .foregroundColor(.textSecondary)

                            HStack(spacing: 12) {
                                ForEach(Mood.allCases, id: \.self) { mood in
                                    MoodButton(mood: mood, isSelected: viewModel.selectedMood == mood) {
                                        viewModel.selectedMood = mood
                                    }
                                }
                            }
                        }

                        // Dream Type Selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dream Type")
                                .font(.subheadline.bold())
                                .foregroundColor(.textSecondary)

                            HStack(spacing: 8) {
                                ForEach(DreamType.allCases, id: \.self) { type in
                                    DreamTypeButton(type: type, isSelected: viewModel.selectedDreamType == type) {
                                        viewModel.selectedDreamType = type
                                    }
                                }
                            }
                        }

                        // Tags Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.subheadline.bold())
                                .foregroundColor(.textSecondary)

                            FlowLayout(spacing: 8) {
                                ForEach(viewModel.tags, id: \.self) { tag in
                                    TagChip(tag: tag) {
                                        viewModel.removeTag(tag)
                                    }
                                }

                                TagInputField(tag: $viewModel.newTag) {
                                    viewModel.addTag()
                                }
                            }
                        }

                        Spacer(minLength: 100)
                    }
                    .padding()
                }

                // Save Button
                VStack {
                    Spacer()
                    Button(action: saveDream) {
                        Text("Save Dream")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.canSave ? AppGradient.accentDiagonal : LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(16)
                    }
                    .disabled(!viewModel.canSave)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("New Dream")
            .navigationBarTitleDisplayMode(.inline)
            .toolBarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.accentPrimary)
                }
            }
        }
    }

    func saveDream() {
        viewModel.save()
        dismiss()
    }
}

struct DreamTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.surface)
            .cornerRadius(12)
            .foregroundColor(.textPrimary)
    }
}

struct VoiceRecordingView: View {
    @Binding var isRecording: Bool
    @Binding var duration: TimeInterval

    var body: some View {
        HStack(spacing: 16) {
            Button(action: { isRecording.toggle() }) {
                ZStack {
                    Circle()
                        .fill(isRecording ? Color.error : Color.accentPrimary)
                        .frame(width: 56, height: 56)

                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }

            if isRecording {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recording...")
                        .font(.subheadline.bold())
                        .foregroundColor(.textPrimary)

                    Text(formatDuration(duration))
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                // Animated waveform
                HStack(spacing: 2) {
                    ForEach(0..<20, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.accentPrimary)
                            .frame(width: 4, height: CGFloat.random(in: 8...32))
                            .animation(.easeInOut(duration: 0.2).repeatForever(), value: isRecording)
                    }
                }
            }
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(12)
    }

    func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(mood.emoji)
                    .font(.title2)
                Text(mood.rawValue.capitalized)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .accentPrimary : .textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.accentPrimary.opacity(0.2) : Color.surface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentPrimary : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct DreamTypeButton: View {
    let type: DreamType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: type.icon)
                    .font(.caption)
                Text(type.displayName)
                    .font(.caption.bold())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentPrimary : Color.surface)
            .foregroundColor(isSelected ? .white : .textSecondary)
            .cornerRadius(8)
        }
    }
}

struct TagChip: View {
    let tag: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text("#\(tag)")
                .font(.caption)
                .foregroundColor(.accentPrimary)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.accentPrimary.opacity(0.7))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.accentPrimary.opacity(0.15))
        .cornerRadius(12)
    }
}

struct TagInputField: View {
    @Binding var tag: String
    let onAdd: () -> Void

    var body: some View {
        HStack {
            TextField("Add tag...", text: $tag)
                .font(.caption)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.surface)
                .cornerRadius(8)
                .onSubmit(onAdd)

            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.accentPrimary)
            }
            .disabled(tag.isEmpty)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in width: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > width, x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: width, height: y + rowHeight)
        }
    }
}

class AddDreamViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var isRecording: Bool = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var selectedMood: Mood = .neutral
    @Published var selectedDreamType: DreamType = .normal
    @Published var tags: [String] = []
    @Published var newTag: String = ""

    var canSave: Bool {
        !title.isEmpty && !content.isEmpty
    }

    func addTag() {
        guard !newTag.isEmpty, !tags.contains(newTag) else { return }
        tags.append(newTag)
        newTag = ""
    }

    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }

    func save() {
        let dream = DreamEntry(
            title: title,
            content: content,
            mood: selectedMood,
            dreamType: selectedDreamType,
            tags: tags,
            createdAt: Date()
        )
        DatabaseService.shared.insertDream(dream)
    }
}