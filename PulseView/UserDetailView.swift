import SwiftUI
import WidgetKit

struct UserDetailView: View {
    let user: WhatPulseUser
    @State private var isFavorite: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.03, green: 0.05, blue: 0.1), Color(red: 0.0, green: 0.1, blue: 0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text(user.accountName)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.cyan)
                        Spacer()
                        ShareLink(item: shareText) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.cyan)
                                .imageScale(.large)
                                .padding(.trailing, 10)
                        }

                        Button(action: {
                            let defaults = UserDefaults(suiteName: "group.pulseview")
                            if isFavorite {
                                defaults?.removeObject(forKey: "widget_user")
                            } else {
                                defaults?.set(user.accountName, forKey: "widget_user")
                            }
                            isFavorite.toggle()
                            WidgetCenter.shared.reloadAllTimelines()
                        }) {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .imageScale(.large)
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)

                    Text("Joined: \(formatISODate(user.dateJoined))")
                        .foregroundColor(.gray)
                    Text("Last Pulse: \(formatISODate(user.lastPulse))")
                        .foregroundColor(.gray)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(title: "Keystrokes", value: formatNumber(user.keys), icon: "⌨️", rank: formatRank(user.ranks.keys))
                        StatCard(title: "Clicks", value: formatNumber(user.clicks), icon: "🖱", rank: formatRank(user.ranks.clicks))
                        StatCard(title: "Download", value: formatBytes(user.downloadMB * 1024 * 1024), icon: "⬇️", rank: formatRank(user.ranks.download))
                        StatCard(title: "Upload", value: formatBytes(user.uploadMB * 1024 * 1024), icon: "⬆️", rank: formatRank(user.ranks.upload))
                        
                        if let miles = user.distanceInMiles {
                            StatCard(title: "Distance", value: formatDistance(miles: miles), icon: "📏", rank: formatRank(user.ranks.distance))
                        } else {
                            StatCard(title: "Distance", value: "N/A", icon: "📏", rank: nil)
                        }
                        
                        let uptimeSeconds = Int(user.uptimeSeconds) ?? 0
                        StatCard(title: "Uptime", value: formatUptime(seconds: uptimeSeconds), icon: "🕖", rank: "\(user.ranks.uptime)")
                    }

                    // 📊 Fun Stats Section
                    VStack(alignment: .leading, spacing: 8) {
                        Divider().background(Color.white.opacity(0.2))
                        Text("📊 Insights")
                            .font(.headline)
                            .foregroundColor(.cyan)

                        Text("• \(user.accountName) averages \(keysPerDay) keystrokes per day.")
                        Text("• \(user.accountName) averages \(clicksPerDay) clicks per day.")
                        Text("• In total, \(user.accountName) downloaded approximately \(downloadPerDay) per day.")
                        Text("• In total, \(user.accountName) uploaded approximately \(uploadPerDay) per day.")
                        Text("• \(user.accountName) moved their mouse to circle a stadium \(distanceInStadiums).")
                        Text("• \(user.accountName)'s computers ran for around \(uptimeDays) days.")
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .cornerRadius(12)
                }
            }
        }
        .onAppear {
            let current = UserDefaults(suiteName: "group.pulseview")?.string(forKey: "widget_user")
            isFavorite = current == user.accountName
        }
    }

    // 🟦 Fun Breakdown Calculations

    var uptimeDays: Int {
        let seconds = Int(user.uptimeSeconds) ?? 0
        return max(1, seconds / 86400)
    }

    var keysPerDay: Int {
        user.keys / uptimeDays
    }

    var clicksPerDay: Int {
        user.clicks / uptimeDays
    }

    var downloadPerDay: String {
        let dailyMB = Double(user.downloadMB) / Double(uptimeDays)
        return formatBytes(Int(dailyMB * 1024 * 1024))
    }
    
    var uploadPerDay: String {
        let dailyMB = Double(user.uploadMB) / Double(uptimeDays)
        return formatBytes(Int(dailyMB * 1024 * 1024))
    }

    var distanceInStadiums: String {
        if let miles = user.distanceInMiles {
            let stadiums = miles / 0.11938
            return String(format: "%.0f rounds", stadiums)
        } else {
            return "N/A"
        }
    }

    // 🟦 Share-Text
    var shareText: String {
        """
        🚀 Tracked with PulseView – the fanmade WhatPulse Companion App!

        📊 Stats from \(user.accountName):
        ⌨️ Keystrokes: \(formatNumber(user.keys))
        🖱 Clicks: \(formatNumber(user.clicks))
        ⬇️ Download: \(formatBytes(user.downloadMB * 1024 * 1024))
        ⬆️ Upload: \(formatBytes(user.uploadMB * 1024 * 1024))
        🕘 Uptime: \(formatUptime(seconds: Int(user.uptimeSeconds) ?? 0))

        📲 Get the app: https://go.nebuliton.io/pulse  
        ℹ️ Stats powered by WhatPulse.org
        """
    }
}

// MARK: - StatCard View

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let rank: String?

    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 30))
                .padding(.top, 8)

            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.cyan)

            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            if let rank = rank {
                Text("🏆 \(rank)")
                    .font(.caption2)
                    .foregroundColor(.yellow)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.03), Color.blue.opacity(0.08)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Formatierhilfen

func formatNumber(_ number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
}

func formatBytes(_ bytes: Int) -> String {
    let units = ["B", "KiB", "MiB", "GiB", "TiB"]
    var value = Double(bytes)
    var index = 0

    while value >= 1024 && index < units.count - 1 {
        value /= 1024
        index += 1
    }

    return String(format: "%.2f %@", value, units[index])
}
func formatRank(_ value: String) -> String {
    if let number = Int(value) {
        return formatNumber(number)
    } else {
        return value
    }
    
}
