import SwiftUI

struct MainWatchView: View {
    @StateObject private var fetcher = WatchUserFetcher()
    @AppStorage("watchUsername") private var username: String = ""
    @State private var tempUsername = ""
    @State private var showInput = false
    @State private var showSettings = false
    @State private var showInsights = false
    @State private var visibleCardCount = 0

    var body: some View {
        ZStack {
            // 🔹 Hintergrund
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.4)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // 🔹 Inhalt
            ScrollView {
                VStack(spacing: 12) {
                        HStack {
                            // 👤 Username & Stift als ein Button
                            Button(action: {
                                showInput = true
                            }) {
                                HStack(spacing: 6) {
                                    Text("👤 \(username.isEmpty ? "No user" : username)")
                                        .font(.headline)
                                        .foregroundColor(.cyan)
                                    Image(systemName: "pencil")
                                        .foregroundColor(.cyan)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                            
                            // ℹ️ Info-Button wie gehabt
                            Button(action: {
                                showSettings = true
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.cyan)
                                    .padding(6)
                                    .background(Color.white.opacity(0.05))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                    
                    Divider().background(Color.cyan.opacity(0.4))
                    
                    if let user = fetcher.user {
                        Button(action: {
                            showInsights = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chart.bar.fill")
                                Text("Insights")
                            }
                            .font(.footnote)
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .stroke(Color.cyan, lineWidth: 1)
                                    .background(Color.white.opacity(0.05).clipShape(Capsule()))
                            )
                        }
                        
                        Divider().background(Color.white.opacity(0.1))
                        
                        VStack(spacing: 12) {
                            if visibleCardCount >= 1 {
                                StatCard(title: "Keystrokes", value: formatNumber(user.keys), rank: formatRank(user.ranks.keys))
                            }
                            if visibleCardCount >= 2 {
                                StatCard(title: "Clicks", value: formatNumber(user.clicks), rank: formatRank(user.ranks.clicks))
                            }
                            if visibleCardCount >= 3 {
                                StatCard(title: "Download", value: formatBytes(Double(user.downloadMB) * 1024 * 1024), rank: formatRank(user.ranks.download))
                            }
                            if visibleCardCount >= 4 {
                                StatCard(title: "Upload", value: formatBytes(Double(user.uploadMB) * 1024 * 1024), rank: formatRank(user.ranks.upload))
                            }
                            if visibleCardCount >= 5 {
                                StatCard(title: "Uptime", value: formatUptime(seconds: user.uptimeSeconds), rank: formatRank(user.ranks.uptime))
                            }
                            if visibleCardCount >= 6 {
                                StatCard(title: "Last Pulse", value: formatISODate(user.lastPulse), rank: nil)
                            }
                        }
                        
                    } else {
                        if username.isEmpty {
                            Text("Add a username to see stats!")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.top, 30)
                        } else if let error = fetcher.errorMessage {
                            Text("⚠️ \(error)")
                                .foregroundColor(.yellow)
                                .multilineTextAlignment(.center)
                                .padding(.top, 30)
                        } else {
                            Text("Loading stats...")
                                .foregroundColor(.gray)
                                .padding(.top, 30)
                        }
                    }
                }
                .padding()
            }
            
            // 🔹 Sheets
            .sheet(isPresented: $showInput) {
                VStack(spacing: 10) {
                    Text("Enter Username")
                        .font(.headline)
                        .foregroundColor(.cyan)
                    
                    TextField("Username", text: $tempUsername)
                        .padding(6)
                        .frame(width: 120)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.cyan, lineWidth: 1)
                                .background(Color.white.opacity(0.05))
                        )
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Button("Save") {
                        username = tempUsername.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !username.isEmpty {
                            fetcher.update()
                        }
                        showInput = false
                    }
                    .padding(.top, 5)
                }
                .padding()
                .background(Color.black)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showInsights) {
                if let user = fetcher.user {
                    InsightsView(user: user)
                } else {
                    Text("No user data available.")
                        .foregroundColor(.gray)
                }
            }
            // 🔹 Animation beim Laden
            .onAppear {
                if !username.isEmpty {
                    fetcher.update()
                }
            }
            .onChange(of: fetcher.user != nil) { _ in
                withAnimation {
                    visibleCardCount = 0
                }
                for i in 1...6 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.7)) {
                        withAnimation {
                            visibleCardCount = i
                        }
                    }
                }
            }
        }
    }
    // MARK: - Format Helpers

    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    func formatBytes(_ bytes: Double) -> String {
        let units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB"]
        var value = bytes
        var index = 0
        while value >= 1024 && index < units.count - 1 {
            value /= 1024
            index += 1
        }
        return String(format: "%.2f %@", value, units[index])
    }

    func formatUptime(seconds: Int) -> String {
        var remaining = seconds
        let years = remaining / (365 * 24 * 3600)
        remaining %= 365 * 24 * 3600
        let weeks = remaining / (7 * 24 * 3600)
        remaining %= 7 * 24 * 3600
        let days = remaining / (24 * 3600)
        remaining %= 24 * 3600
        let hours = remaining / 3600
        remaining %= 3600
        let minutes = remaining / 60
        let secs = remaining % 60

        var parts: [String] = []
        if years > 0 { parts.append("\(years)y") }
        if weeks > 0 { parts.append("\(weeks)w") }
        if days > 0 { parts.append("\(days)d") }
        if hours > 0 { parts.append("\(hours)h") }
        if minutes > 0 { parts.append("\(minutes)m") }
        if secs > 0 || parts.isEmpty { parts.append("\(secs)s") }

        return parts.joined(separator: " ")
    }

    func formatISODate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = formatter.date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            displayFormatter.locale = Locale(identifier: "en_US")
            return displayFormatter.string(from: date)
        } else {
            return isoString
        }
    }

    func formatRank(_ value: String) -> String {
        if let number = Int(value) {
            return formatNumber(number)
        } else {
            return value
        }
    }
}

// MARK: - StatCard

struct StatCard: View {
    let title: String
    let value: String
    let rank: String?

    var body: some View {
        VStack(spacing: 4) {
            Text(title.uppercased())
                .font(.caption2)
                .foregroundColor(.cyan)

            Text(value)
                .font(.headline)
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
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .shadow(color: .black.opacity(0.3), radius: 3, y: 1)
        )
    }
}
