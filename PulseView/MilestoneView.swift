// MilestoneView.swift
import SwiftUI

struct MilestoneDetail: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let milestones: [Int]
    let currentValue: Int
}

struct MilestoneView: View {
    @StateObject private var fetcher = UserStatsFetcher()
    @State private var selectedDetail: MilestoneDetail? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.03, green: 0.05, blue: 0.1),
                                                Color(red: 0.0, green: 0.1, blue: 0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if let user = fetcher.starUser {
                    ScrollView {
                        VStack(spacing: 24) {
                            PulsePathHeaderView(userName: user.accountName)

                            ForEach(MilestoneData.categories(for: user), id: \.title) { category in
                                MilestoneCategoryView(
                                    title: category.title,
                                    value: category.currentValue,
                                    milestones: category.milestones,
                                    onTap: {
                                        selectedDetail = MilestoneDetail(
                                            title: category.title,
                                            milestones: category.milestones,
                                            currentValue: category.currentValue
                                        )
                                    }
                                )
                            }

                            Spacer(minLength: 40)
                        }
                        .padding()
                    }
                } else {
                    VStack(spacing: 20) {
                        PulsePathHeaderView(userName: nil)
                            .padding(.top)

                        Text("No PulsePath user set yet")
                            .font(.title3)
                            .foregroundColor(.cyan)

                        Text("Go to the 'Others' tab and tap ⭐ to track a user’s PulsePath.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.cyan.opacity(0.5))
                            .padding(.top, 12)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onAppear {
                fetcher.loadStarUser()
            }
            .navigationDestination(item: $selectedDetail) { detail in
                MilestoneDetailView(
                    title: detail.title,
                    milestones: detail.milestones,
                    currentValue: detail.currentValue
                )
            }
        }
    }
}

// MARK: - PulsePathHeaderView (Required View)

struct PulsePathHeaderView: View {
    let userName: String?

    var body: some View {
        VStack(spacing: 12) {
            PulseCircleView(icon: "figure.walk.circle.fill", color: .cyan, size: 80)
                .padding(.top, 20)

            Text("PulsePath")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.cyan)

            Text("Every step counts on your PulsePath. Choose a user on the Others tab!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let userName = userName {
                Text("Tracking: \(userName)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}
