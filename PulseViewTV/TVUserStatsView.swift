import SwiftUI

struct TVUserStatsView: View {
    @StateObject private var fetcher = TVUserFetcher()
    @State private var usernameInput: String = ""

    var body: some View {
        NavigationStack {
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

                VStack(spacing: 40) {
                    Spacer(minLength: 40)

                    if let user = fetcher.user {
                        VStack(spacing: 10) {
                            Text(user.accountName)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)

                            Text("Last Pulse: \(formatPulseDate(user.lastPulse))")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }

                        Grid(alignment: .center, horizontalSpacing: 40, verticalSpacing: 20) {
                            GridRow {
                                statBox(icon: "keyboard", title: "KEYSTROKES", value: user.keys.formatted(), rank: user.ranks.keys)
                                statBox(icon: "cursorarrow.click", title: "CLICKS", value: user.clicks.formatted(), rank: user.ranks.clicks)
                            }
                            GridRow {
                                statBox(icon: "arrow.down.circle", title: "DOWNLOAD", value: formatBytes(user.downloadMB), rank: user.ranks.download)
                                statBox(icon: "arrow.up.circle", title: "UPLOAD", value: formatBytes(user.uploadMB), rank: user.ranks.upload)
                            }
                            GridRow {
                                statBox(icon: "figure.walk", title: "DISTANCE", value: formatDistance(user.distanceInMiles), rank: user.ranks.distance)
                                statBox(icon: "clock", title: "UPTIME", value: formatUptime(user.uptimeSeconds), rank: user.ranks.uptime)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Text("No data loaded yet")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }

                    Text("Enter your own or any WhatPulse username to view their stats.")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 4)

                    VStack {
                        HStack {
                            // Eingabefeld + Button
                            HStack(alignment: .center, spacing: 40) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.gray)
                                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)

                                    TextField("Enter username...", text: $usernameInput)
                                        .foregroundColor(.cyan) // Text immer schwarz
                                        .padding(.horizontal)
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .accentColor(.black) // Cursor auch schwarz
                                        .onAppear {
                                            UITextField.appearance().defaultTextAttributes = [.foregroundColor: UIColor.black]
                                        }
                                }
                            
                                // Lade-Button im Stil des Textfelds
                                Button(action: {
                                    let trimmed = usernameInput.trimmingCharacters(in: .whitespacesAndNewlines)
                                    usernameInput = trimmed
                                    saveLastUsername(trimmed)
                                    fetcher.update(for: trimmed)
                                }) {
                                    Text("Save")
                                        .font(.title3)
                                        .bold()
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 24)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .fill(Color.white)
                                        )
                                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                                        .foregroundColor(.cyan)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.leading, 100)

                            Spacer()
                            
                            if let user = fetcher.user {
                                NavigationLink(destination: InsightsView(user: user)) {
                                    Text("View Insights")
                                        .font(.title3)
                                        .bold()
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 24)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .fill(Color.white)
                                        )
                                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                                        .foregroundColor(.mint)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            // Zahnrad-Button ganz rechts
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 22))
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(Color.cyan.opacity(0.2))
                                            .frame(width: 50, height: 50)
                                            .shadow(color: .cyan.opacity(0.3), radius: 8, y: 3)
                                    )
                                    .foregroundColor(.cyan)
                            }
                            .padding(.trailing, 100)
                        }

                        Spacer(minLength: 40)
                    }

                    if let error = fetcher.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 4)
                    }
                }
            }
            .onAppear {
                if let saved = loadLastUsername() {
                    usernameInput = saved
                    fetcher.update(for: saved)
                }
                fetcher.startAutoUpdate()
            }
            .onDisappear {
                fetcher.stopAutoUpdate()
            }
        }
    }

    // MARK: - UI-Helfer

    private func statBox(icon: String, title: String, value: Int, rank: String) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(formatNumber(value))
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            HStack(spacing: 4) {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.yellow)
                Text("#\(rank)")
                    .font(.footnote)
                    .foregroundColor(.yellow)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(red: 0.09, green: 0.11, blue: 0.17))
        .cornerRadius(16)
    }

    private func statBox(icon: String, title: String, value: String, rank: String) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            HStack(spacing: 4) {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.yellow)
                Text("#\(rank)")
                    .font(.footnote)
                    .foregroundColor(.yellow)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(red: 0.09, green: 0.11, blue: 0.17))
        .cornerRadius(16)
    }

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func formatBytes(_ mb: Int) -> String {
        let tb = Double(mb) / 1_000_000
        return String(format: "%.2f TB", tb)
    }

    private func formatDistance(_ miles: Double?) -> String {
        guard let miles = miles else { return "-" }
        return String(format: "%.2f mi", miles)
    }

    private func formatUptime(_ seconds: Int) -> String {
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

        return "\(years)y \(weeks)w \(days)d \(hours)h \(minutes)m"
    }

    private func formatPulseDate(_ isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: isoDate) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return isoDate
    }

    private func saveLastUsername(_ name: String) {
        let defaults = UserDefaults(suiteName: "group.pulseview")
        defaults?.set(name, forKey: "last_tv_username")
    }

    private func loadLastUsername() -> String? {
        let defaults = UserDefaults(suiteName: "group.pulseview")
        return defaults?.string(forKey: "last_tv_username")
    }
}
