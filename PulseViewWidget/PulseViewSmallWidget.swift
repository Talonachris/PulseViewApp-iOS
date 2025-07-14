import SwiftUI
import WidgetKit

struct PulseViewSmallWidget: Widget {
    let kind: String = "PulseViewSmallWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PulseViewSmallWidgetView(entry: entry)
        }
        .configurationDisplayName("PulseView (Small)")
        .description("Compact WhatPulse stats view.")
        .supportedFamilies([.systemSmall])
    }
}

struct PulseViewSmallWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            if entry.user.accountName == "No user" {
                Text("No user")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                let user = entry.user

                VStack(alignment: .center, spacing: 4) {
                    // PulseView Logo + Name
                    HStack(spacing: 4) {
                        Image("pulseview_icon_tint")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.tint)

                        Text(user.accountName)
                            .font(.caption)
                            .foregroundColor(.cyan)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }

                    // Grid mit 4 Werten
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 2), spacing: 4) {
                        stat("⌨️", formatShort(user.keys))
                        stat("🖱", formatShort(user.clicks))
                        stat("⬇️", shortBytes(user.downloadMB * 1024 * 1024))
                        stat("⬆️", shortBytes(user.uploadMB * 1024 * 1024))
                    }
                }
                .padding(8)
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
            Text(icon).font(.caption2)
            Text(value)
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity)
    }

    // Reuse aus deinem Widget
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

    func formatISODate(_ isoDateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoDateString) else { return "–" }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM. HH:mm"
        return formatter.string(from: date)
    }
}
