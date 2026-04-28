import SwiftUI

@main
struct DreamoraAiProApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}

class AppState: ObservableObject {
    @Published var isPremium: Bool = false
    @Published var hasCompletedOnboarding: Bool = false

    init() {
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "onboardingCompleted")
    }

    func unlockPremium() {
        isPremium = true
        UserDefaults.standard.set(true, forKey: "isPremium")
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
    }
}