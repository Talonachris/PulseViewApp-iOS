import SwiftUI

struct AboutView: View {
    @AppStorage("pelleTapCount") private var tapCount: Int = 0
    @State private var showPelle = false
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.03, green: 0.05, blue: 0.1), Color(red: 0.0, green: 0.1, blue: 0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Image("pulseview_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .shadow(color: .cyan.opacity(0.6), radius: 20)
                        .onTapGesture {
                            tapCount += 1
                            if tapCount >= 3 {
                                withAnimation(.easeInOut) {
                                    showPelle = true
                                }
                                tapCount = 0
                            }
                        }
                    
                    Text("PulseView")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.cyan)
                    
                    Text("Version \(appVersion) (Build \(buildNumber))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 24) {
                            VStack(spacing: 6) {
                                Image("Talonachris")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                                
                                Text("Talonachris")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.cyan)
                                
                                Text("Made PulseView with ❤️")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            
                            VStack(spacing: 6) {
                                Image("smitmartijn")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                                
                                Text("smitmartijn")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.cyan)
                                
                                Text("Without you, PulseView wouldn't exist!")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 12)
                    
                    Divider().background(Color.white.opacity(0.1))
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        LinkCard(imageName: "nebuliton_logo", title: "Nebuliton.io", url: URL(string:"https://nebuliton.io"))
                        LinkCard(imageName: "whatpulse_icon",  title: "WhatPulse.org", url: URL(string:"https://whatpulse.org"))
                        LinkCard(imageName: "Talonachris",     title: "Talonachris.de", url: URL(string:"https://www.talonachris.de/english-homepage/"))
                    }
                    
                    Divider().background(Color.white.opacity(0.1)).padding(.vertical, 4)
                    
                    Text("PulseView is an independent fan-made project and not officially affiliated with WhatPulse – yet 😉.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Divider().background(Color.white.opacity(0.2)).padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🔍 About PulseView")
                            .font(.headline)
                            .foregroundColor(.cyan)
                        
                        Text("PulseView was built by a WhatPulse enthusiast from Germany who simply wanted a sleek way to check their stats.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text("Back then, no app existed – so I decided to code one myself. Now it’s here to help others, too.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text("💬 Got ideas or feedback?")
                            .font(.headline)
                            .foregroundColor(.cyan)
                        
                        Text("Ask Talonachris on the WhatPulse Discord or visit our Nebuliton website!")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    Section(header: Text("Privacy").foregroundColor(.cyan)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PulseView does not collect personal data. All data shown is retrieved from the public WhatPulse API. No login, tracking or analytics are used.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                            Link("🖋️ PulseView Privacy Policy", destination: URL(string: "https://talonachris.github.io/pulseview-pages/legal")!)
                                .foregroundColor(.cyan)
                                .font(.footnote)
                            
                            Link("🖋️ WhatPulse Privacy Policy", destination: URL(string: "https://whatpulse.org/privacy/")!)
                                .foregroundColor(.cyan)
                                .font(.footnote)
                        }
                    }
                    
                    Image("nebuliton_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: .orange.opacity(0.4), radius: 10)
                        .padding(.top, 16)
                    
                    Text("Pulseview is an App of Nebuliton")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("© 2025 by Nebuliton")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            
            if showPelle {
                ZStack {
                    Color.black.opacity(0.9)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                showPelle = false
                            }
                        }
                    
                    VStack(spacing: 16) {
                        PulseyGlowView()
                            .padding(.top, 24)
                        
                        Text("Say hi to Pulsey – your stat buddy! 🎉")
                            .foregroundColor(.white)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    .transition(.scale)
                }
                .transition(.opacity)
            }
        }
    }
    
    struct LinkCard: View {
        let imageName: String
        let title: String
        let url: URL?
        @Environment(\.openURL) private var openURL
        
        var body: some View {
            HStack(spacing: 12) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    .shadow(radius: 3)
                
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .bold()
                
                Spacer()
                
                Image(systemName: "arrow.up.right.square")
                    .font(.footnote)
                    .foregroundColor(.cyan)
            }
            .padding(10)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
            )
            .contentShape(Rectangle()) // ganze Karte tappable
            .onTapGesture { if let u = url { openURL(u) } }
            .accessibilityElement()
            .accessibilityLabel(Text(title))
            .accessibilityAddTraits(.isButton)
        }
    }
}
