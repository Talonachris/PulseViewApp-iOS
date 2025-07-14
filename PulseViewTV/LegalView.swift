import SwiftUI

struct LegalView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer(minLength: 60)

                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.cyan)

                Text("PulseView is an independent companion app for viewing and comparing public WhatPulse statistics.")
                    .foregroundColor(.white)

                Text("No Data Collection")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.cyan)

                Text("This app does not collect, store or transmit any personal data. All usage is local to your device.")
                    .foregroundColor(.white.opacity(0.85))

                Text("API Usage")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.cyan)

                Text("PulseView connects to the public WhatPulse API to retrieve public statistics (keystrokes, clicks, etc.) of users you choose to view.\n\nNo account login, email, or private information is ever requested or accessed by this app.")
                    .foregroundColor(.white.opacity(0.85))

                Text("Third-Party Policy")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.cyan)

                VStack(alignment: .leading, spacing: 8) {
                    Text("For more information about WhatPulse and their data practices, please refer to their official privacy policy:")
                        .foregroundColor(.white.opacity(0.85))

                    Text("https://whatpulse.org/privacy")
                        .foregroundColor(.cyan)
                        .italic()
                }

                Text("Developer Info")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.cyan)

                Text("This app is developed and published by Nebuliton.")
                    .foregroundColor(.white.opacity(0.85))

                Spacer(minLength: 60)
            }
            .padding(.horizontal, 60)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.07, green: 0.09, blue: 0.13)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}
