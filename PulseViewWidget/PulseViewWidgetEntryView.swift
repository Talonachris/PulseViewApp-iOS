import SwiftUI
import WidgetKit

struct PulseViewWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.clear

            if entry.user.accountName == "No user" {
                Text("No user selected")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                let user = entry.user

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image("pulseview_icon_tint")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(.tint) // Wichtig für automatische Systemfärbung

                        VStack(alignment: .leading, spacing: 1) {
                            Text(user.accountName)
                                .font(.subheadline)
                                .foregroundColor(.cyan)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)

                            Text(formatISODate(user.lastPulse))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                        stat("⌨️", formatShort(user.keys))
                        stat("🖱", formatShort(user.clicks))
                        stat("⬇️", shortBytes(user.downloadMB * 1024 * 1024))
                        stat("⬆️", shortBytes(user.uploadMB * 1024 * 1024))
                        if let miles = user.distanceInMiles {
                            stat("📏", shortDistance(miles))
                        }
                        stat("🕖", uptimeAsYMD(seconds: user.uptimeSeconds))
                    }
                }
                .padding(10)
            }
        }
        .containerBackground(for: .widget) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.03, green: 0.05, blue: 0.1),
                    Color(red: 0.0, green: 0.1, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    func stat(_ icon: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(icon).font(.caption)
            Text(value)
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity)
    }

    func formatShort(_ number: Int) -> String {
        let value = Double(number)
        switch value {
        case 1_000_000...: return String(format: "%.1fM", value / 1_000_000)
        case 1_000...: return String(format: "%.1fk", value / 1_000)
        default: return "\(number)"
        }
    }

    func shortBytes(_ bytes: Int) -> String {
        let value = Double(bytes)
        if value >= 1_099_511_627_776 { return String(format: "%.1f TB", value / 1_099_511_627_776) }
        if value >= 1_073_741_824 { return String(format: "%.1f GB", value / 1_073_741_824) }
        if value >= 1_048_576 { return String(format: "%.1f MB", value / 1_048_576) }
        if value >= 1024 { return String(format: "%.1f KB", value / 1024) }
        return String(format: "%.0f B", value)
    }

    func shortDistance(_ miles: Double) -> String {
        let km = miles * 1.60934
        return String(format: "%.0fkm", km)
    }

    func uptimeAsYMD(seconds: Int) -> String {
        let days = seconds / 86400
        let years = days / 365
        let months = (days % 365) / 30
        let remainingDays = (days % 365) % 30

        var parts: [String] = []
        if years > 0 { parts.append("\(years)y") }
        if months > 0 { parts.append("\(months)mo") }
        if remainingDays > 0 || parts.isEmpty { parts.append("\(remainingDays)d") }

        return parts.joined(separator: " ")
    }
}
