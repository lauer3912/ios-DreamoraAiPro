import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)

            DreamJournalView()
                .tabItem {
                    Label("Journal", systemImage: selectedTab == 1 ? "book.fill" : "book")
                }
                .tag(1)

            SleepTrackerView()
                .tabItem {
                    Label("Sleep", systemImage: selectedTab == 2 ? "moon.fill" : "moon")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                }
                .tag(3)
        }
        .tint(.accentPrimary)
    }
}