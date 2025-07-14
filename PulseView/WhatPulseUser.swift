import Foundation

struct WhatPulseAPIResponse: Codable {
    let user: WhatPulseUser
}

struct WhatPulseUser: Codable, Identifiable {
    var id: String { accountName }

    let accountName: String
    let keys: Int
    let clicks: Int
    let downloadMB: Int
    let uploadMB: Int
    let uptimeSeconds: Int
    let dateJoined: String
    let lastPulse: String
    let distanceInMiles: Double?
    let ranks: UserRanks

    enum CodingKeys: String, CodingKey {
        case username
        case dateJoined = "date_joined"
        case lastPulseDate = "last_pulse_date"
        case totals
        case ranks
    }

    struct UserRanks: Codable {
        let keys: String
        let clicks: String
        let download: String
        let upload: String
        let uptime: String
        let scrolls: String
        let distance: String

        enum CodingKeys: String, CodingKey {
            case keys
            case clicks
            case download
            case upload
            case uptime
            case scrolls
            case distance
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            keys = String(try container.decode(Int.self, forKey: .keys))
            clicks = String(try container.decode(Int.self, forKey: .clicks))
            download = String(try container.decode(Int.self, forKey: .download))
            upload = String(try container.decode(Int.self, forKey: .upload))
            uptime = String(try container.decode(Int.self, forKey: .uptime))
            scrolls = String(try container.decode(Int.self, forKey: .scrolls))
            distance = String(try container.decode(Int.self, forKey: .distance))
        }

        init(keys: String, clicks: String, download: String, upload: String, uptime: String, scrolls: String, distance: String) {
            self.keys = keys
            self.clicks = clicks
            self.download = download
            self.upload = upload
            self.uptime = uptime
            self.scrolls = scrolls
            self.distance = distance
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(Int(keys) ?? 0, forKey: .keys)
            try container.encode(Int(clicks) ?? 0, forKey: .clicks)
            try container.encode(Int(download) ?? 0, forKey: .download)
            try container.encode(Int(upload) ?? 0, forKey: .upload)
            try container.encode(Int(uptime) ?? 0, forKey: .uptime)
            try container.encode(Int(scrolls) ?? 0, forKey: .scrolls)
            try container.encode(Int(distance) ?? 0, forKey: .distance)
        }
    }

    struct UserTotals: Codable {
        let keys: Int
        let clicks: Int
        let downloadMB: Int
        let uploadMB: Int
        let uptimeSeconds: Int
        let distanceMiles: Double

        enum CodingKeys: String, CodingKey {
            case keys
            case clicks
            case downloadMB = "download_mb"
            case uploadMB = "upload_mb"
            case uptimeSeconds = "uptime_seconds"
            case distanceMiles = "distance_miles"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        accountName = try container.decode(String.self, forKey: .username)
        dateJoined = try container.decode(String.self, forKey: .dateJoined)
        lastPulse = try container.decode(String.self, forKey: .lastPulseDate)
        ranks = try container.decode(UserRanks.self, forKey: .ranks)

        let totals = try container.decode(UserTotals.self, forKey: .totals)
        keys = totals.keys
        clicks = totals.clicks
        downloadMB = totals.downloadMB
        uploadMB = totals.uploadMB
        uptimeSeconds = totals.uptimeSeconds
        distanceInMiles = totals.distanceMiles
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountName, forKey: .username)
        try container.encode(dateJoined, forKey: .dateJoined)
        try container.encode(lastPulse, forKey: .lastPulseDate)
        try container.encode(ranks, forKey: .ranks)

        let totals = UserTotals(
            keys: keys,
            clicks: clicks,
            downloadMB: downloadMB,
            uploadMB: uploadMB,
            uptimeSeconds: uptimeSeconds,
            distanceMiles: distanceInMiles ?? 0.0
        )
        try container.encode(totals, forKey: .totals)
    }

    // 🔧 Manueller Initializer für direkte Zuweisung (z. B. für placeholder)
    init(
        accountName: String,
        keys: Int,
        clicks: Int,
        downloadMB: Int,
        uploadMB: Int,
        uptimeSeconds: Int,
        dateJoined: String,
        lastPulse: String,
        distanceInMiles: Double?,
        ranks: UserRanks
    ) {
        self.accountName = accountName
        self.keys = keys
        self.clicks = clicks
        self.downloadMB = downloadMB
        self.uploadMB = uploadMB
        self.uptimeSeconds = uptimeSeconds
        self.dateJoined = dateJoined
        self.lastPulse = lastPulse
        self.distanceInMiles = distanceInMiles
        self.ranks = ranks
    }

    static var placeholder: WhatPulseUser {
        .init(
            accountName: "SampleUser",
            keys: 123456,
            clicks: 78910,
            downloadMB: 12345,
            uploadMB: 6789,
            uptimeSeconds: 36000,
            dateJoined: "2024-01-01",
            lastPulse: "2025-05-30",
            distanceInMiles: 12.3,
            ranks: UserRanks(
                keys: "999",
                clicks: "999",
                download: "999",
                upload: "999",
                uptime: "999",
                scrolls: "999",
                distance: "999"
            )
        )
    }
    var lastPulseFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: lastPulse) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return lastPulse
    }
}
