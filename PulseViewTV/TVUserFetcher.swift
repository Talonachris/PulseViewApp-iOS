import Foundation

class TVUserFetcher: ObservableObject {
    @Published var user: WhatPulseUser?
    @Published var errorMessage: String?

    private var timer: Timer?

    func update(for username: String) {
        WhatPulseAPI.fetchUser(username: username) { user in
            DispatchQueue.main.async {
                if let user = user {
                    self.user = user
                    self.errorMessage = nil
                } else {
                    self.user = nil
                    self.errorMessage = "Unknown or private user"
                }
            }
        }
    }

    func startAutoUpdate() {
        stopAutoUpdate()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            if let user = self.user {
                self.update(for: user.accountName)
            }
        }
    }

    func stopAutoUpdate() {
        timer?.invalidate()
        timer = nil
    }
}
