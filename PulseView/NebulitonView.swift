import SwiftUI

struct NebulitonView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.12, green: 0.09, blue: 0.2),
                        Color(red: 0.18, green: 0.1, blue: 0.27)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        headerSection
                        aboutSection
                        offerSection
                        discordSection
                        footerNote
                    }
                    .padding()
                }
            }
            .navigationTitle("Nebuliton")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var headerSection: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.3))
                    .frame(width: 180, height: 180)
                    .blur(radius: 24)

                PulseCircleView(icon: "bolt.fill", color: .purple, size: 180)
                    .frame(width: 100, height: 100)

                Image("nebuliton_logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: .purple.opacity(0.5), radius: 14, x: 0, y: 6)
            }

            Text("Welcome to Nebuliton")
                .font(.title2).bold()
                .foregroundColor(.white)
                .padding(.top, 16)

            Text("A small and passionate hosting team from Kiel, Germany – powered by Ryzen and heart.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }

    private var aboutSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Divider().background(Color.white.opacity(0.1))

            Text("🇩🇪 German-based, but open to everyone.")
                .font(.headline)
                .foregroundColor(.white)

            Text("Nebuliton is a young hosting brand based in northern Germany. We focus on reliability, transparency and performance – with Ryzen-powered root servers, modern infrastructure and personal support.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }

    private var offerSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Divider().background(Color.white.opacity(0.1))

            Text("🧩 What we offer")
                .font(.headline)
                .foregroundColor(.white)

            VStack(spacing: 8) {
                Label("Root Servers (KVM, full access)", systemImage: "cpu")
                Label("Game Server Hosting", systemImage: "gamecontroller")
                Label("Web Hosting & Domains", systemImage: "globe")
                Label("Uptime Kuma Monitoring", systemImage: "waveform.path.ecg")
            }
            .foregroundColor(.white.opacity(0.9))
            .font(.subheadline)
            .multilineTextAlignment(.center)
        }
    }

    private var discordSection: some View {
        VStack(spacing: 20) {
            Text("Who we are")
                .font(.headline)
                .foregroundColor(.white)

            Text("We’re not a faceless company – we're passionate gamers and developers. Nebuliton is a hobby-driven project, built out of joy, not greed.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Text("We love what we do – and that includes offering high-performance root servers, game servers, Uptime Kuma dashboards, domain services and more.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Text("No call centers. No empty promises. Just real people, real service – and our dog Pelle 🐶")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)

            Link(destination: URL(string: "https://discord.gg/nebuliton")!) {
                Label("Join our Discord!", systemImage: "bubble.left.and.bubble.right.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Link(destination: URL(string: "https://nebuliton.io")!) {
                Label("Visit our Website", systemImage: "globe")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Text("❤️ Created with love by a small team – and proudly powering PulseView.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 30)
    }

    private var footerNote: some View {
        VStack(spacing: 6) {
            Divider().background(Color.white.opacity(0.1))

            Text("Proud creators of PulseView.")
                .font(.footnote)
                .foregroundColor(.gray)

            Text("© 2025 Nebuliton – Serverschmiede der Galaxien")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(.top, 32)
    }
}
