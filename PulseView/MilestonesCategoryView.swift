import SwiftUI

struct MilestoneCategoryView: View {
    let title: String
    let value: Int
    let milestones: [Int]
    let onTap: (() -> Void)?

    var nextMilestone: Int {
        milestones.first(where: { value < $0 }) ?? milestones.last ?? value
    }

    var progress: Double {
        guard nextMilestone > 0 else { return 1.0 }
        return min(Double(value) / Double(nextMilestone), 1.0)
    }

    var progressPercent: Int {
        Int(progress * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background layer
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 10)

                    // Foreground progress
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * CGFloat(progress), height: 10)
                }
            }
            .frame(height: 10)

            HStack {
                Text(formatValue(value))
                Spacer()
                Text("Next: \(formatValue(nextMilestone))")
            }
            .font(.caption)
            .foregroundColor(.gray)

            HStack {
                Spacer()
                Text("\(progressPercent)%")
                    .font(.caption2)
                    .foregroundColor(.cyan)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .onTapGesture {
            onTap?()
        }
    }

    // MARK: - Formatters

    func formatValue(_ value: Int) -> String {
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
        let units = ["B", "KB", "MB", "GB", "TB", "PB", "EB"]
        var value = Double(bytes)
        var unitIndex = 0

        while value >= 1024 && unitIndex < units.count - 1 {
            value /= 1024
            unitIndex += 1
        }

        return String(format: "%.2f %@", value, units[unitIndex])
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
}
