import SwiftUI

struct HomeView: View {
    @StateObject private var fetcher = UserStatsFetcher()
    @EnvironmentObject var store: UserStore
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.03, green: 0.05, blue: 0.1), Color(red: 0.0, green: 0.1, blue: 0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer()
                        
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
                            
                            Image("pulseview_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .shadow(color: .cyan.opacity(0.5), radius: 10)
                        }
                        
                        Text("Welcome to")
                            .foregroundColor(.cyan)
                            .font(.title3)
                        
                        Text("PulseView")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Compare WhatPulse users by keystrokes,\nclicks, downloads, uptime and more.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .padding(.horizontal)
                        
                        Text("👋 Start by selecting a user in the *User* tab to view detailed stats.")
                            .font(.headline)
                            .foregroundColor(.cyan)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            FeatureRow(icon: "keyboard", title: "Activity Insights", subtitle: "Keystrokes, clicks & distance – visualized beautifully.")
                            FeatureRow(icon: "chart.bar.fill", title: "Custom Rankings", subtitle: "Sort users by keys, clicks, downloads & more.")
                            FeatureRow(icon: "trophy.fill", title: "Achievements", subtitle: "Track your PulsePath with stat milestones.")
                            FeatureRow(icon: "person.3.fill", title: "Compare Users", subtitle: "Store, favorite & compare WhatPulse users.")
                            FeatureRow(icon: "bolt.fill", title: "Widget Support", subtitle: "Your stats – right on your home screen.")
                            FeatureRow(icon: "heart.fill", title: "Made with ❤️", subtitle: "Created for stat lovers & perfectionists.")
                        }
                        .padding(.horizontal)
                        
                        Divider().background(Color.white.opacity(0.1)).padding(.vertical, 4)
                        
                        Text("🔗 Links")
                            .font(.headline)
                            .foregroundColor(.cyan)
                        
                        HStack(alignment: .top, spacing: 32) {
                            // Nebuliton
                            Link(destination: URL(string: "https://nebuliton.de")!) {
                                VStack(spacing: 8) {
                                    Image("nebuliton_logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .shadow(color: .orange.opacity(0.3), radius: 8)
                                    
                                    Text("Nebuliton")
                                        .font(.footnote)
                                        .foregroundColor(.cyan)
                                }
                                .frame(width: 72)
                            }
                            
                            // WhatPulse
                            Link(destination: URL(string: "https://whatpulse.org")!) {
                                VStack(spacing: 8) {
                                    Image("whatpulse_icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .shadow(color: .cyan.opacity(0.5), radius: 8)
                                    
                                    Text("WhatPulse")
                                        .font(.footnote)
                                        .foregroundColor(.cyan)
                                }
                                .frame(width: 72)
                            }
                        }
                        .padding(.top, 24)
                        
                        Spacer(minLength: 60) // Abstand zum Tab-Menü
                    }
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView().environmentObject(store)) {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.large)
                                .foregroundColor(.cyan)
                                .padding(8)
                                .background(Color.cyan.opacity(0.1))
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                    }
                }
            }
        }
    }
    
    
    struct FeatureRow: View {
        let icon: String
        let title: String
        let subtitle: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.cyan)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .bold()
                    
                    Text(subtitle)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
        }
    }
}
