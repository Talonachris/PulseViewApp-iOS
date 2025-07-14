import SwiftUI

struct SettingsView: View {
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "–"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "–"
        return "v\(version) (\(build))"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 🔷 App Name
                Text("PulseView")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.cyan)

                // 📱 Beschreibung
                Text("The fanmade WhatPulse App for Apple Watch.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.footnote)

                // 🌸 Haiku
                VStack(spacing: 2) {
                    Text("Tiny on my wrist,")
                    Text("Numbers pulse with every move,")
                    Text("My clicks remembered.")
                }
                .font(.footnote.italic())
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 8)

                Divider().background(Color.white.opacity(0.2))

                // 🧾 Version & Info
                Text("Version: \(appVersion)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))

                Text("Made with ❤️ by Talonachris")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.9))

                Text("© 2025 Nebuliton")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}
