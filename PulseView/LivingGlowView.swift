import SwiftUI

struct LivingGlowView: View {
    @State private var animate = false

    var body: some View {
        RoundedRectangle(cornerRadius: 32)
            .strokeBorder(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.cyan.opacity(1.0),
                        Color.purple.opacity(0.8),
                        Color.blue.opacity(1.0),
                        Color.purple.opacity(0.8),
                        Color.cyan.opacity(1.0)
                    ]),
                    startPoint: animate ? .topLeading : .bottomTrailing,
                    endPoint: animate ? .bottomTrailing : .topLeading
                ),
                lineWidth: 16
            )
            .frame(width: 340, height: 340)
            .blur(radius: 32)
            .opacity(1.0)
            .rotationEffect(.degrees(animate ? 12 : -12))
            .hueRotation(.degrees(animate ? 45 : -30))
            .animation(.easeInOut(duration: 7.0).repeatForever(autoreverses: true), value: animate)
            .onAppear {
                animate = true
            }
            .shadow(color: .cyan.opacity(0.6), radius: 40, x: 0, y: 0)
            .shadow(color: .purple.opacity(0.5), radius: 30, x: 10, y: 10)
    }
}
