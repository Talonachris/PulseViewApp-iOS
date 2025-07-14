import WidgetKit
import SwiftUI

@main
struct PulseViewWidgetBundle: WidgetBundle {
    var body: some Widget {
        PulseViewWidget()       // Großes Haupt-Widget
        PulseViewSmallWidget() // Kleines kompaktes Widget
        // 🔜 Weitere Widgets hier einfügen, z. B.:
        // PulseViewMilestoneWidget()
        // PulseViewAchievementsWidget()
    }
}
