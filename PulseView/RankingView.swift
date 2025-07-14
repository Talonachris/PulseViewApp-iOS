import SwiftUI

struct RankingView: View {
    @ObservedObject private var store = UserStore()
    @State private var selectedStat: String = "keys"
    
    private let categories: [(key: String, label: String)] = [
        ("keys", "Keystrokes"),
        ("clicks", "Clicks"),
        ("downloadMB", "Download"),
        ("uploadMB", "Upload"),
        ("uptimeSeconds", "Uptime"),
        ("distanceInMiles", "Distance")
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.02, green: 0.05, blue: 0.1), Color(red: 0.0, green: 0.08, blue: 0.18)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                PulseCircleView(icon: "trophy.fill", color: .cyan, size: 70)
                    .padding(.top, 10)

                Text("Ranking")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.cyan)

                Picker("Kategorie", selection: $selectedStat) {
                    ForEach(categories, id: \.key) { category in
                        Text(category.label)
                            .foregroundColor(.white)
                            .tag(category.key)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.horizontal)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)

                List {
                    ForEach(sortedUsers.enumerated().map { $0 }, id: \.element.accountName) { index, user in
                        HStack {
                            Text(rankingEmoji(for: index) + " \(user.accountName)")
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text(value(for: user))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text("Rank \(formatNumber(Int(rank(for: user, selectedStat: selectedStat)) ?? 0))")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.vertical, 6)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
            .padding(.bottom)
        }
    }

    // MARK: - Sortierung

    private var sortedUsers: [WhatPulseUser] {
        store.users.sorted {
            valueRaw(for: $0) > valueRaw(for: $1)
        }
    }

    private func valueRaw(for user: WhatPulseUser) -> Double {
        switch selectedStat {
        case "keys": return Double(user.keys)
        case "clicks": return Double(user.clicks)
        case "downloadMB": return Double(user.downloadMB)
        case "uploadMB": return Double(user.uploadMB)
        case "uptimeSeconds": return Double(Int(user.uptimeSeconds) ?? 0)
        case "distanceInMiles": return user.distanceInMiles ?? 0.0
        default: return 0
        }
    }

    private func value(for user: WhatPulseUser) -> String {
        switch selectedStat {
        case "keys", "clicks":
            return formatNumber(Int(valueRaw(for: user)))
        case "downloadMB", "uploadMB":
            return formatBytes(Int(valueRaw(for: user) * 1024 * 1024))
        case "uptimeSeconds":
            return formatUptime(seconds: Int(valueRaw(for: user)))
        case "distanceInMiles":
            return formatDistance(miles: valueRaw(for: user))
        default:
            return "-"
        }
    }

    private func rankingEmoji(for index: Int) -> String {
        switch index {
        case 0: return "🥇"
        case 1: return "🥈"
        case 2: return "🥉"
        default: return "#\(index + 1)"
        }
    }

    private func rank(for user: WhatPulseUser, selectedStat: String) -> String {
        switch selectedStat {
        case "keys": return user.ranks.keys
        case "clicks": return user.ranks.clicks
        case "downloadMB": return user.ranks.download
        case "uploadMB": return user.ranks.upload
        case "uptimeSeconds": return user.ranks.uptime
        case "distanceInMiles": return user.ranks.distance
        default: return "-"
        }
    }
}
