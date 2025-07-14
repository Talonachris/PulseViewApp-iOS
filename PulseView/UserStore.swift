import Foundation

class UserStore: ObservableObject {
    @Published var users: [WhatPulseUser] = []
    static let shared = UserStore()
    
    init() {
        loadUsers()
    }
    
    func addUser(_ user: WhatPulseUser) {
        if !users.contains(where: { $0.accountName == user.accountName }) {            users.append(user)
            saveUsers()
        }
    }
    
    func removeUser(at index: Int) {
        users.remove(at: index)
        saveUsers()
    }
    
    func removeUserFromRanking(_ user: WhatPulseUser) {
        users.removeAll { $0.accountName == user.accountName }
    }
    
    func flushUsers() {
        users.removeAll()
        UserDefaults.standard.removeObject(forKey: "savedUsers")
        print("✅ UserStore flushed")
    }
    
    func refreshAllUsers() {
        let usernames = users.map { $0.accountName }
        users = [] // Reset, damit es auch visuell neu lädt
        for username in usernames {
            WhatPulseAPI.fetchUser(username: username) { user in
                DispatchQueue.main.async {
                    if let user = user {
                        self.addUser(user)
                    }
                }
            }
        }
    }
    
    private func saveUsers() {
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: "savedUsers")
        }
    }
    
    private func loadUsers() {
        if let data = UserDefaults.standard.data(forKey: "savedUsers"),
           let decoded = try? JSONDecoder().decode([WhatPulseUser].self, from: data) {
            users = decoded
        }
    }
}
