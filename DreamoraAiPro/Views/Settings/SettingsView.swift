import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                List {
                    // Account Section
                    Section {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.accentPrimary)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Guest User")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)
                                Text(appState.isPremium ? "Premium Member" : "Free Plan")
                                    .font(.caption)
                                    .foregroundColor(appState.isPremium ? .accentPrimary : .textSecondary)
                            }

                            Spacer()

                            if !appState.isPremium {
                                NavigationLink(destination: PremiumView()) {
                                    Text("Upgrade")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(AppGradient.accentDiagonal)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .listRowBackground(Color.surface)
                    }

                    // Subscription
                    Section("Subscription") {
                        if appState.isPremium {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.warning)
                                Text("Premium Active")
                                    .foregroundColor(.textPrimary)
                                Spacer()
                                Text("Renewed Monthly")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            .listRowBackground(Color.surface)

                            Button(action: { }) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Restore Purchases")
                                }
                                .foregroundColor(.accentPrimary)
                            }
                            .listRowBackground(Color.surface)
                        } else {
                            NavigationLink(destination: PremiumView()) {
                                HStack {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(.warning)
                                    Text("Upgrade to Premium")
                                    Spacer()
                                    Text("$4.99/mo")
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            .listRowBackground(Color.surface)
                        }
                    }

                    // Notifications
                    Section("Notifications") {
                        Toggle(isOn: $settings.morningReminder) {
                            HStack {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.accentSecondary)
                                Text("Morning Dream Reminder")
                            }
                        }
                        .tint(.accentPrimary)
                        .listRowBackground(Color.surface)

                        Toggle(isOn: $settings.weeklyReport) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.accentPrimary)
                                Text("Weekly Sleep Report")
                            }
                        }
                        .tint(.accentPrimary)
                        .listRowBackground(Color.surface)

                        Toggle(isOn: $settings.motivationalTips) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.warning)
                                Text("Motivational Tips")
                            }
                        }
                        .tint(.accentPrimary)
                        .listRowBackground(Color.surface)
                    }

                    // Appearance
                    Section("Appearance") {
                        Toggle(isOn: $settings.darkMode) {
                            HStack {
                                Image(systemName: "moon.fill")
                                    .foregroundColor(.accentPrimary)
                                Text("Dark Mode")
                            }
                        }
                        .tint(.accentPrimary)
                        .listRowBackground(Color.surface)
                    }

                    // Data
                    Section("Data") {
                        Button(action: exportData) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.accentPrimary)
                                Text("Export All Dreams")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .foregroundColor(.textPrimary)
                        .listRowBackground(Color.surface)

                        Button(action: { }) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(.accentSecondary)
                                Text("Export as PDF")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .foregroundColor(.textPrimary)
                        .listRowBackground(Color.surface)

                        Button(action: { }) {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.error)
                                Text("Delete All Data")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .foregroundColor(.error)
                        .listRowBackground(Color.surface)
                    }

                    // Support
                    Section("Support") {
                        Link(destination: URL(string: "https://dreamora.app/privacy")!) {
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(.accentPrimary)
                                Text("Privacy Policy")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .foregroundColor(.textPrimary)
                        .listRowBackground(Color.surface)

                        Link(destination: URL(string: "https://dreamora.app/terms")!) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.accentPrimary)
                                Text("Terms of Service")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .foregroundColor(.textPrimary)
                        .listRowBackground(Color.surface)

                        Button(action: { }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.accentSecondary)
                                Text("Contact Support")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .foregroundColor(.textPrimary)
                        .listRowBackground(Color.surface)

                        Button(action: rateApp) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.warning)
                                Text("Rate Dreamora")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .foregroundColor(.textPrimary)
                        .listRowBackground(Color.surface)

                        Button(action: shareApp) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.accentPrimary)
                                Text("Share with Friends")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .foregroundColor(.textPrimary)
                        .listRowBackground(Color.surface)
                    }

                    // About
                    Section("About") {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.textSecondary)
                        }
                        .listRowBackground(Color.surface)

                        Button(action: resetOnboarding) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(.accentPrimary)
                                Text("Reset Onboarding")
                            }
                        }
                        .foregroundColor(.textPrimary)
                        .listRowBackground(Color.surface)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            
        }
    }

    @State private var settings = SettingsState()

    func exportData() {
        // Export functionality
    }

    func rateApp() {
        // Open App Store rating
    }

    func shareApp() {
        // Share app link
    }

    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "onboardingCompleted")
        appState.hasCompletedOnboarding = false
    }
}

struct SettingsState {
    var morningReminder: Bool = true
    var weeklyReport: Bool = true
    var motivationalTips: Bool = false
    var darkMode: Bool = true
}