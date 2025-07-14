import SwiftUI

struct MilestoneDetailView: View {
    let title: String
    let milestones: [Int]
    let currentValue: Int

    @State private var showPelleCelebration = false
    @State private var pelleImageName: String? = nil
    @State private var activeMilestone: Int? = nil

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    header

                    ForEach(milestones, id: \.self) { milestone in
                        milestoneCard(for: milestone)
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }

            if showPelleCelebration, let imageName = pelleImageName {
                ZStack {
                    Color.black.opacity(0.95).ignoresSafeArea()

                    VStack(spacing: 16) {
                            ZStack {
                                LivingGlowView() // Hintergrundglow
                                
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 280, height: 280)
                                    .clipShape(RoundedRectangle(cornerRadius: 32))
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 6)
                            }

                        Text(pelleMilestoneText(for: imageName))
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.top, 12)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        showPelleCelebration = false
                    }
                }
                .transition(.opacity)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(showPelleCelebration ? .hidden : .visible, for: .navigationBar)
    }

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.03, green: 0.05, blue: 0.1),
                Color(red: 0.0, green: 0.1, blue: 0.2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var header: some View {
        HStack {
            Spacer()
            Text("Your PulsePath: \(title)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.cyan)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.top, 12)
    }

    private func milestoneCard(for milestone: Int) -> some View {
        let progress = min(Double(currentValue) / Double(milestone), 1.0)
        let achieved = currentValue >= milestone

        let barFill = LinearGradient(
            gradient: Gradient(colors: achieved ? [.green] : [Color.cyan, Color.blue]),
            startPoint: .leading,
            endPoint: .trailing
        )

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(formatMilestone(milestone))
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: achieved ? "checkmark.seal.fill" : "circle")
                    .foregroundColor(achieved ? .green : .gray)
                    .imageScale(.large)
            }

            GeometryReader { geometry in
                let fullWidth = geometry.size.width
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 10)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(barFill)
                        .frame(width: fullWidth * CGFloat(progress), height: 10)
                        .shadow(color: achieved ? .green.opacity(1.0) : .clear, radius: 12)
                }
            }
            .frame(height: 10)

            Text("\(formatPercentage(currentValue, milestone))%")
                .font(.caption)
                .foregroundColor(.gray)

            if achieved {
                if let funny = funnyMilestoneText(for: milestone) {
                    Text(funny)
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            Group {
                if achieved {
                    Text("Tap me")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.cyan.opacity(0.7))
                        .clipShape(Capsule())
                        .offset(x: -12, y: -12)
                        .transition(.scale)
                }
            },
            alignment: .topTrailing
        )
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .onTapGesture {
            if achieved {
                pelleImageName = getPelleImage(for: milestone)
                activeMilestone = milestone
                withAnimation {
                    showPelleCelebration = true
                }
            }
        }
    }

    // MARK: - Formatters & Helpers

    func formatMilestone(_ value: Int) -> String {
        if title.contains("Download") || title.contains("Upload") {
            return formatBytes(value)
        } else if title.contains("Uptime") {
            return formatUptime(value)
        } else {
            return formatNumber(value)
        }
    }

    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    func formatBytes(_ bytes: Int) -> String {
        let thresholds: [(Double, String)] = [
            (pow(1024, 5), "PB"),
            (pow(1024, 4), "TB"),
            (pow(1024, 3), "GB"),
            (pow(1024, 2), "MB"),
            (1024, "KB")
        ]

        let byteDouble = Double(bytes)
        for (threshold, unit) in thresholds {
            if byteDouble >= threshold {
                return String(format: "%.2f %@", byteDouble / threshold, unit)
            }
        }
        return "\(bytes) B"
    }

    func formatUptime(_ seconds: Int) -> String {
        let years = seconds / 31_536_000
        let days = (seconds % 31_536_000) / 86400
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60

        var components: [String] = []
        if years > 0 { components.append("\(years)y") }
        if days > 0 { components.append("\(days)d") }
        if hours > 0 { components.append("\(hours)h") }
        if minutes > 0 { components.append("\(minutes)m") }
        if secs > 0 { components.append("\(secs)s") }

        return components.joined(separator: " ")
    }

    func formatPercentage(_ value: Int, _ target: Int) -> String {
        let percentage = min(Double(value) / Double(target), 1.0) * 100
        return String(format: "%.0f", percentage)
    }

    func getPelleImage(for milestone: Int) -> String? {
        let categoryKey = title.lowercased().components(separatedBy: " ").first ?? ""
        let fullKey = "\(categoryKey)_\(milestone)"

        let imageMap: [String: String] = [
            // Keystrokes
            "keystrokes_100000": "pelle_01",
            "keystrokes_1000000": "pelle_02",
            "keystrokes_10000000": "pelle_03",
            "keystrokes_100000000": "pelle_04",
            "keystrokes_1000000000": "pelle_05",
            
            // Clicks
            "clicks_50000": "pelle_06",
            "clicks_500000": "pelle_07",
            "clicks_5000000": "pelle_08",
            "clicks_50000000": "pelle_09",
            "clicks_500000000": "pelle_10",
            
            // Download
            "download_1099511627776": "pelle_11",          // 1 TB
            "download_10995116277760": "pelle_12",         // 10 TB
            "download_109951162777600": "pelle_13",        // 100 TB
            "download_1125899906842624": "pelle_14",       // 1 PB
            "download_11258999068426240": "pelle_15",      // 10 PB
            
            // Upload
            "upload_1099511627776": "pelle_16",
            "upload_10995116277760": "pelle_17",
            "upload_109951162777600": "pelle_18",
            "upload_1125899906842624": "pelle_19",
            "upload_11258999068426240": "pelle_20",
            
            // Uptime
            "uptime_86400": "pelle_21",
            "uptime_604800": "pelle_22",
            "uptime_31536000": "pelle_23",
            "uptime_315360000": "pelle_24",
            "uptime_3153600000": "pelle_25",
            
            // Distance
            "distance_100": "pelle_26",
            "distance_500": "pelle_27",
            "distance_1000": "pelle_28",
            "distance_5000": "pelle_29",
            "distance_10000": "pelle_30",
            "distance_50000": "pelle_31",
            "distance_100000": "pelle_32",
            "distance_1000000": "pelle_33"
        ]
        
        return imageMap[fullKey]
    }
    
    func pelleMilestoneText(for imageName: String) -> String {
        let pelleTexts: [String: String] = [
            "pelle_01": "Pelle heard your typing and nodded in approval. 🐾⌨️",
            "pelle_02": "Pelle just filed a report: 'Keyboard enthusiast detected'. 🐶📋",
            "pelle_03": "Pelle wonders: Are you coding... or summoning demons? 😈🐕",
            "pelle_04": "Pelle’s ears perked up – that was loud! 🐶👂",
            "pelle_05": "Pelle’s paws are jealous of your typing skills. 🐾💻",
            "pelle_06": "Pelle blinked at the clicks – are you gaming without him? 🎮🐶",
            "pelle_07": "Pelle clicked once. You clicked 500,000x. Balance. ☯️🐾",
            "pelle_08": "Pelle’s mousepad is now a no-click zone. 👀🖱️",
            "pelle_09": "Pelle howled in amazement. 🐺💥",
            "pelle_10": "Pelle thinks you owe your mouse an apology. 🙃🐶",
            "pelle_11": "Pelle snuck into your downloads folder... just memes. 😅📂",
            "pelle_12": "Pelle streamed all seasons of 'Dogs Unleashed'. 🐶🎬",
            "pelle_13": "Pelle’s cache is full. Yours isn’t. 🚀🐾",
            "pelle_14": "Pelle detected a wormhole in your bandwidth. 🌌🐕",
            "pelle_15": "NASA called. Pelle forwarded your logs. 🚀📡",
            "pelle_16": "Pelle uploaded his bark to the cloud. ☁️🐶",
            "pelle_17": "Your upload speed made Pelle's ears flap. 🐕💨",
            "pelle_18": "Pelle sniffed your traffic. Smells like data. 📈🐽",
            "pelle_19": "Pelle waves from the other end of your upload. 👋🐶",
            "pelle_20": "Pelle’s tail wagged to your bandwidth beat. 🎶🐾",
            "pelle_21": "Pelle watched you stay online... he took naps. 💤🐶",
            "pelle_22": "Pelle’s uptime: 3h. Yours: insane. 🧠🐕",
            "pelle_23": "One year online? Pelle suggests going for a walk. 🚶‍♂️🐾",
            "pelle_24": "Pelle consulted the Matrix. You’re in. 🟩🐕",
            "pelle_25": "Pelle is now your digital familiar. 💫🐶",
            "pelle_26": "Pelle followed your mouse trail – and got tired. 🐕‍🦺💻",
            "pelle_27": "500 miles? Even Pelle is impressed. 🥾🐾",
            "pelle_28": "Pelle fetched your cursor – eventually. 🎯🐶",
            "pelle_29": "Pelle did a marathon just watching you move the mouse. 🐾🏃‍♂️",
            "pelle_30": "Pelle's paws tingled from your scrolling. 🔁🐾",
            "pelle_31": "Pelle circled the globe with your mouse path. 🌍🐕",
            "pelle_32": "Pelle’s space suit is packed. Let’s go! 🚀🐶",
            "pelle_33": "Pelle is lost in the galaxy – blame your distance stat. 🌌🐾"
        ]

        return pelleTexts[imageName] ?? "Pelle is very, very proud of you! 🐶"
    }

    func funnyMilestoneText(for milestone: Int) -> String? {
        let normalizedTitle = title.lowercased()

        if normalizedTitle.contains("key") {
            return funnyMilestoneTexts["keystrokes"]?[milestone]
        } else if normalizedTitle.contains("click") {
            return funnyMilestoneTexts["clicks"]?[milestone]
        } else if normalizedTitle.contains("download") {
            return funnyMilestoneTexts["download"]?[milestone]
        } else if normalizedTitle.contains("upload") {
            return funnyMilestoneTexts["upload"]?[milestone]
        } else if normalizedTitle.contains("uptime") {
            return funnyMilestoneTexts["uptime"]?[milestone]
        } else if normalizedTitle.contains("distance") {
            return funnyMilestoneTexts["distance"]?[milestone]
        }

        return nil
    }

    var funnyMilestoneTexts: [String: [Int: String]] {
        let gib = 1_073_741_824
        let tib = gib * 1024
        let pib = tib * 1024

        return [
            "keystrokes": [
                100_000: "Typed like 100 DIN A4 pages 💬",
                1_000_000: "Enough keystrokes for a novel 📖",
                10_000_000: "Could have written 100 fanfictions 😅",
                100_000_000: "Keyboard? What keyboard? 🔥",
                1_000_000_000: "Certified keyboard killer 💀⌨️"
            ],
            "clicks": [
                50_000: "Clicked more than your crush's Instagram 💘",
                500_000: "Professional cookie clicker 🍪",
                5_000_000: "Might be a League player 😬",
                50_000_000: "Mouse: 'Please stop' 🖱️💢",
                500_000_000: "Official mouse abuser award 🏆"
            ],
            "download": [
                gib: "Downloaded a movie 🍿",
                tib: "500 Netflix movies 🎥",
                tib * 10: "You hoarder! 📦",
                tib * 100: "All of Wikipedia maybe 🤔",
                pib: "You broke the Matrix 💾"
            ],
            "upload": [
                gib: "Shared a meme folder 📁",
                tib: "Leaked Marvel script 🦸",
                tib * 10: "Backup in the cloud ☁️",
                tib * 100: "Sharing is caring 💞",
                pib: "New Google Drive 📡"
            ],
            "uptime": [
                86400: "Online for one full day 🌅",
                604800: "One week uptime – you okay? 🧠",
                31_536_000: "One year online – digital citizen 👤",
                315_360_000: "Ten years? You sure? 🤖",
                3_153_600_000: "Eternal machine overlord 👑"
            ],
            "distance": [
                100: "Your mouse took a long walk 🐾",
                500: "You've crossed Denmark 🇩🇰",
                1_000: "Roadtrip mouse unlocked 🚗",
                5_000: "You made it coast-to-coast 🇺🇸",
                10_000: "You've seen Europe by scrollwheel 🌍",
                50_000: "You circled the Earth! 🌎",
                100_000: "Halfway to the Moon 🚀",
                1_000_000: "Mouse left the solar system ☄️"
            ]
        ]
    }
}
