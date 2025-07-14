import SwiftUI

struct MainTabView: View {
    @StateObject private var store = UserStore()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(store) // ✅ WICHTIG für z. B. SettingsView in Home
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            MeView()
                .environmentObject(store)
                .tabItem {
                    Label("Me", systemImage: "person")
                }
                .tag(1)

            UserListView()
                .environmentObject(store)
                .tabItem {
                    Label("User", systemImage: "person.3.fill")
                }
                .tag(2)

            MilestoneView()
                .environmentObject(store)
                .tabItem {
                    Label("PulsePath", systemImage: "figure.walk")
                }
                .tag(3)

            RankingView()
                .environmentObject(store)
                .tabItem {
                    Label("Ranking", systemImage: "trophy")
                }
                .tag(4)
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
}
