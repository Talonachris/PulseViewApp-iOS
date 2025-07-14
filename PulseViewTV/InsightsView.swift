import SwiftUI

struct InsightsView: View {
    let user: WhatPulseUser

    var body: some View {
        ZStack {
            // 🔹 Hintergrund
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.07, green: 0.09, blue: 0.13),
                    Color(red: 0.05, green: 0.07, blue: 0.10),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 40) {
                    Spacer(minLength: 60)

                    // 🔹 Username oben
                    Text(user.accountName)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(color: .mint.opacity(0.4), radius: 10, y: 6)

                    // 🔹 PulseCircle
                    PulseCircleView(icon: "bolt.fill", color: .mint, size: 200)

                    // 🔹 Join-Datum & Dauer
                    VStack(spacing: 8) {
                        Text("You joined WhatPulse on")
                            .foregroundColor(.gray)
                            .font(.title3)

                        Text(formatJoinDate(user.dateJoined))
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)

                        Text("That's \(membershipDuration(from: user.dateJoined)) now!")
                            .foregroundColor(.mint)
                            .font(.headline)
                    }

                    Divider().background(Color.white.opacity(0.2))

                    // 🔹 Zwei Spalten mit Fakten
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                        statBox(icon: "doc.plaintext", text: "\(pagesTyped) A4 pages typed")
                        statBox(icon: "globe", text: "Your mouse travelled \(distanceAroundEarth)x around the Earth")
                        statBox(icon: "film", text: "\(netflixMoviesDownloaded) Netflix movies downloaded")
                        statBox(icon: "arrow.up.to.line", text: "\(youtubeVideosUploaded) YouTube 15 min videos uploaded")
                        statBox(icon: "clock", text: "\(formattedUptime(user.uptimeSeconds)) online time")
                    }

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 80)
            }
        }
    }

    // MARK: - Berechnungen

    var pagesTyped: Int {
        user.keys / 2900
    }

    var distanceAroundEarth: String {
        let earthMiles = 24901.0
        let times = (user.distanceInMiles ?? 0) / earthMiles
        return String(format: "%.4f", times)
    }

    var netflixMoviesDownloaded: Int {
        user.downloadMB / 1500
    }

    var youtubeVideosUploaded: Int {
        user.uploadMB / 500
    }

    func formattedUptime(_ seconds: Int) -> String {
        let days = seconds / 86400
        let hours = (seconds % 86400) / 3600
        return "\(days)d \(hours)h"
    }

    func formatJoinDate(_ iso: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: iso) {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
        return iso
    }

    func membershipDuration(from iso: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let joinDate = isoFormatter.date(from: iso) else { return "a long time" }

        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month], from: joinDate, to: now)
        let years = components.year ?? 0
        let months = components.month ?? 0
        return "\(years) years and \(months) months"
    }

    // MARK: - Stat Box
    func statBox(icon: String, text: String) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.cyan)
                .frame(width: 32, height: 32)
                .alignmentGuide(.firstTextBaseline) { d in d[VerticalAlignment.center] }

            Text(text)
                .foregroundColor(.white)
                .font(.body)
                .multilineTextAlignment(.leading)

            Spacer()
        }
    }
}
