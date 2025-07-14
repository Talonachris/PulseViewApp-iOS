import WidgetKit
import SwiftUI

struct PulseViewWidget: Widget {
    let kind: String = "PulseViewWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PulseViewWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("PulseView Stats")
        .description("Shows your latest WhatPulse stats.")
        .supportedFamilies([.systemMedium]) // Optional: .systemSmall, .systemLarge etc.
    }
}
