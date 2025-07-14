import SwiftUI

struct InsightsView: View {
    let user: WhatPulseUser

    var body: some View {
        ZStack {
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
                VStack(spacing: 32) {
                    Spacer(minLength: 20)

                    // Username
                    Text(user.accountName.isEmpty ? "Unknown user" : user.accountName)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(color: .mint.opacity(0.4), radius: 6, y: 3)

                    VStack(spacing: 6) {
                        Text("You joined WhatPulse on")
                            .foregroundColor(.gray)
                            .font(.footnote)

                        Text(formatJoinDate(user.dateJoined))
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)

                        Text("That's \(membershipDuration(from: user.dateJoined)) now!")
                            .foregroundColor(.mint)
                            .font(.footnote)
                    }

                    Divider().background(Color.white.opacity(0.2))

                    VStack(spacing: 16) {
                        statBox(icon: "doc.plaintext", text: "\(pagesTyped) pages written")
                        statBox(icon: "globe", text: "\(distanceAroundEarth)x Earth roundings")
                        statBox(icon: "film", text: "\(netflixMoviesDownloaded) Netflix movies downloaded")
                        statBox(icon: "arrow.up.to.line", text: "\(youtubeVideosUploaded) YouTube videos uploaded")
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
        }
    }

    // MARK: - Berechnungen

    var pagesTyped: Int {
        max(user.keys / 2900, 0)
    }

    var distanceAroundEarth: String {
        let earthMiles = 24901.0
        let miles = user.distanceInMiles ?? 0.0
        let times = miles / earthMiles
        return String(format: "%.2f", times)
    }

    var netflixMoviesDownloaded: Int {
        max(user.downloadMB / 1500, 0)
    }

    var youtubeVideosUploaded: Int {
        max(user.uploadMB / 500, 0)
    }

    func formatJoinDate(_ iso: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: iso) {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
        return "Unknown"
    }

    func membershipDuration(from iso: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let joinDate = isoFormatter.date(from: iso) else { return "a long time" }

        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month], from: joinDate, to: now)
        let years = components.year ?? 0
        let months = components.month ?? 0
        return "\(years)y \(months)m"
    }

    // MARK: - Stat Box

    func statBox(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.cyan)
                .frame(width: 20, height: 20)

            Text(text)
                .foregroundColor(.white)
                .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)

            Spacer()
        }
    }
}
