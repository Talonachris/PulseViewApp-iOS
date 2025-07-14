// MilestoneData.swift
import Foundation

struct MilestoneCategory {
    let title: String
    let milestones: [Int]
    let currentValue: Int
}

struct MilestoneData {
    static func categories(for user: WhatPulseUser) -> [MilestoneCategory] {
        var baseCategories: [MilestoneCategory] = [
            MilestoneCategory(
                title: "Keystrokes",
                milestones: [100_000, 1_000_000, 10_000_000, 100_000_000, 1_000_000_000],
                currentValue: user.keys
            ),
            MilestoneCategory(
                title: "Clicks",
                milestones: [50_000, 500_000, 5_000_000, 50_000_000, 500_000_000],
                currentValue: user.clicks
            ),
            MilestoneCategory(
                title: "Download",
                milestones: [
                    1_073_741_824 * 1024,                // 1 TB
                    1_073_741_824 * 1024 * 10,           // 10 TB
                    1_073_741_824 * 1024 * 100,          // 100 TB
                    1_073_741_824 * 1024 * 1024,         // 1 PB
                    1_073_741_824 * 1024 * 1024 * 10     // 10 PB
                ],
                currentValue: Int(user.downloadMB * 1024 * 1024)
            ),
            MilestoneCategory(
                title: "Upload",
                milestones: [
                    1_073_741_824 * 1024,                // 1 TB
                    1_073_741_824 * 1024 * 10,           // 10 TB
                    1_073_741_824 * 1024 * 100,          // 100 TB
                    1_073_741_824 * 1024 * 1024,         // 1 PB
                    1_073_741_824 * 1024 * 1024 * 10     // 10 PB
                ],
                currentValue: Int(user.uploadMB * 1024 * 1024)
            ),
            MilestoneCategory(
                title: "Uptime",
                milestones: [86400, 604800, 31_536_000, 315_360_000, 3_153_600_000],
                currentValue: user.uptimeSeconds
            )
        ]

        // Optional Distance hinzufügen
        if let distance = user.distanceInMiles {
            let distanceCategory = MilestoneCategory(
                title: "Distance",
                milestones: [100, 500, 1_000, 5_000, 10_000, 50_000, 100_000, 1_000_000],
                currentValue: Int(distance.rounded())
            )
            baseCategories.append(distanceCategory)
        }

        return baseCategories
    }
}
