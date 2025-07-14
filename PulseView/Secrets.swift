import Foundation

enum Secrets {
    static var whatPulseAPIKey: String {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let key = plist["WHATPULSE_API_KEY"] as? String
        else {
            print("❌ Failed to load WHATPULSE_API_KEY from Secrets.plist")
            return ""
        }

        return key
    }
}
