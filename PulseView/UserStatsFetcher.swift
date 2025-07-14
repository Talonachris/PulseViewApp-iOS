import Foundation

class UserStatsFetcher: ObservableObject {
    @Published var starUser: WhatPulseUser?
    @Published var flushTrigger = UUID()
    
    init() {
        loadStarUser()
    }
    
    func loadStarUser() {
        let defaults = UserDefaults(suiteName: "group.pulseview")
        guard let username = defaults?.string(forKey: "widget_user") else {
            print("ℹ️ Kein Favoriten-User gesetzt.")
            return
        }
        
        WhatPulseAPI.fetchUser(username: username) { user in
            DispatchQueue.main.async {
                self.starUser = user
            }
        }
    }
    
    func flushData() {
        self.starUser = nil

        let groupDefaults = UserDefaults(suiteName: "group.pulseview")
        groupDefaults?.removeObject(forKey: "saved_users")
        groupDefaults?.removeObject(forKey: "widget_user")
        groupDefaults?.removeObject(forKey: "pulse_milestones")

        UserDefaults.standard.removeObject(forKey: "starUser")
        UserDefaults.standard.removeObject(forKey: "pulse_milestones")

        // 👉 Trigger UI Refresh
        self.flushTrigger = UUID()

        print("✅ All local data flushed.")
    }
        // Optional für zukünftige OAuth-Nutzung:
        /*
         var token: String? {
         get {
         UserDefaults.standard.string(forKey: "auth_token")
         }
         set {
         UserDefaults.standard.set(newValue, forKey: "auth_token")
         }
         }
         
         var isLoggedIn: Bool {
         return token != nil
         }
         
         func logout() {
         token = nil
         flushData()
         }
         */
    }

