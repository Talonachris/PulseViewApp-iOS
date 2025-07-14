import WidgetKit
import SwiftUI

struct PulseViewEntry: TimelineEntry {
    let date: Date
    let user: WhatPulseUser
}

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> PulseViewEntry {
        PulseViewEntry(date: Date(), user: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (PulseViewEntry) -> Void) {
        let entry = PulseViewEntry(date: Date(), user: .placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PulseViewEntry>) -> Void) {
        let defaults = UserDefaults(suiteName: "group.pulseview")
        let userName = defaults?.string(forKey: "widget_user") ?? "NoUser"

        WhatPulseAPI.fetchUser(username: userName) { fetchedUser in
            let user = fetchedUser ?? .placeholder

            let entry = PulseViewEntry(date: Date(), user: user)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
            completion(timeline)
        }
    }
}
