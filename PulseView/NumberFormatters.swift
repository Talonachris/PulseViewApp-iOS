import Foundation

func formatNumber(_ number: String) -> String {
    let value = Int(number) ?? 0
    return formatInt(value)
}

func formatInt(_ value: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = "."
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
}

func formatDataSize(_ mb: Int) -> String {
    let gb = Double(mb) / 1024
    let tb = gb / 1024

    if tb >= 1 {
        return String(format: "%.2f TB", tb)
    } else if gb >= 1 {
        return String(format: "%.2f GB", gb)
    } else {
        return "\(formatInt(mb)) MB"
    }
}

// ✅ Diese Funktion steht korrekt außerhalb
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

    return "\(years)y \(weeks)w \(days)d \(hours)h \(minutes)m \(secs)s"
}
func formatDistance(miles: Double) -> String {
    let km = miles * 1.60934
    return String(format: "%.2f mi / %.2f km", miles, km)
}
// MARK: - Datum & Zeit

func formatISODate(_ isoString: String) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    if let date = formatter.date(from: isoString) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        displayFormatter.locale = Locale.current
        return displayFormatter.string(from: date)
    } else {
        return isoString // Fallback
    }
}
