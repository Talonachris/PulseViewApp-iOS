import SwiftUI

@main
struct PulseViewApp: App {
    @StateObject private var store = UserStore.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(store) // WICHTIG
                .navigationViewStyle(StackNavigationViewStyle())
                .preferredColorScheme(.dark)
        }
    }
}
