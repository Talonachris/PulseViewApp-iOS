import SwiftUI

struct MeView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            // Hintergrund mit radialem Verlauf
            RadialGradient(
                gradient: Gradient(colors: [Color.cyan.opacity(0.3), Color.black]),
                center: .center,
                startRadius: 5,
                endRadius: 500
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    // Pulsierende Kreise
                    Circle()
                        .stroke(Color.cyan.opacity(0.4), lineWidth: 4)
                        .frame(width: 150, height: 150)
                        .scaleEffect(animate ? 1.2 : 0.8)
                        .opacity(animate ? 0 : 1)
                        .animation(Animation.easeOut(duration: 1.5).repeatForever(autoreverses: false), value: animate)

                    Circle()
                        .stroke(Color.cyan.opacity(0.2), lineWidth: 4)
                        .frame(width: 180, height: 180)
                        .scaleEffect(animate ? 1.3 : 0.9)
                        .opacity(animate ? 0 : 1)
                        .animation(Animation.easeOut(duration: 1.8).repeatForever(autoreverses: false), value: animate)

                    // Zentrales Symbol
                    Image(systemName: "hourglass")
                        .font(.system(size: 50))
                        .foregroundColor(.cyan)
                        .symbolEffect(.pulse, options: .repeat(1), value: animate)
                }

                Text("My Insights")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Text("Coming Soon!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .onAppear {
            animate = true
        }
    }
}
