import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: UserStore

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.03, green: 0.05, blue: 0.1),
                    Color(red: 0.0, green: 0.1, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Deko-Kreis
                    ZStack {
                        Circle()
                            .fill(Color.cyan.opacity(0.1))
                            .frame(width: 140, height: 140)
                            .scaleEffect(1.1)
                            .blur(radius: 4)

                        Circle()
                            .strokeBorder(Color.cyan.opacity(0.4), lineWidth: 4)
                            .frame(width: 120, height: 120)
                            .shadow(color: .cyan, radius: 10)

                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.cyan)
                    }
                    .padding(.top)

                    // About Button
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.cyan)
                            Text("About PulseView")
                                .foregroundColor(.cyan)
                                .bold()
                            Spacer()
                        }
                        .padding()
                        .background(Color.cyan.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Nebuliton Button
                    NavigationLink(destination: NebulitonView()) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.cyan)
                            Text("Who is Nebuliton?")
                                .foregroundColor(.cyan)
                                .bold()
                            Spacer()
                        }
                        .padding()
                        .background(Color.cyan.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Haiku
                    Spacer(minLength: 32)

                    Text("""
                    keys and clicks align

                    data dreams in galaxy

                    every pulse counts.
                    """)
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Spacer(minLength: 60)
                }
                .padding(.top, 32)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
