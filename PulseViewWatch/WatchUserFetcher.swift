import Foundation
import SwiftUI

class WatchUserFetcher: ObservableObject {
    @Published var user: WhatPulseUser?
    @Published var errorMessage: String?

    func update() {
        print("📲 [Fetcher] update() aufgerufen")

        guard let username = UserDefaults.standard.string(forKey: "watchUsername"),
              !username.isEmpty else {
            print("⚠️ [Fetcher] Kein Username gespeichert")
            self.user = nil
            return
        }

        print("🔍 [Fetcher] Username geladen: \(username)")
        print("🌐 [Fetcher] Starte API-Request…")

        WhatPulseAPI.fetchUser(username: username) { user in
            DispatchQueue.main.async {
                if let user = user {
                    print("✅ [Fetcher] Erfolgreich geladen: \(user.accountName)")
                    self.user = user
                    self.errorMessage = nil
                } else {
                    print("❌ [Fetcher] Fehler beim Laden: Keine Nutzerdaten empfangen")
                    self.user = nil
                    self.errorMessage = "Could not load user data"
                }
            }
        }
    }
}
