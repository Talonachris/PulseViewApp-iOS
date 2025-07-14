import SwiftUI

struct UserListView: View {
    @EnvironmentObject var store: UserStore
    @State private var newUsername = ""
    @State private var errorMessage: String?
    @State private var selectedUser: WhatPulseUser? = nil
    @State private var sortOption: SortOption = .name
    @State private var showDeleteConfirmation = false
    @State private var userToDelete: WhatPulseUser? = nil

    enum SortOption: String, CaseIterable, Identifiable {
        case name = "Name"
        case lastPulse = "Last Pulse"

        var id: String { self.rawValue }
    }

    var sortedUsers: [WhatPulseUser] {
        switch sortOption {
        case .name:
            return store.users.sorted { $0.accountName.lowercased() < $1.accountName.lowercased() }
        case .lastPulse:
            return store.users.sorted { $0.lastPulse > $1.lastPulse }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.03, green: 0.05, blue: 0.1), Color(red: 0.0, green: 0.1, blue: 0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        PulseCircleView(icon: "person.3.fill", color: .cyan, size: 60)
                            .padding(.top, 10)

                        Text("📋 User List")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.cyan)
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 34)

                        Picker("Sort by", selection: $sortOption) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 4)
                    }
                    .padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(sortedUsers) { user in
                                Button {
                                    selectedUser = user
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(user.accountName)
                                                .font(.headline)
                                                .foregroundColor(.white)

                                            Text("Last Pulse: \(formatISODate(user.lastPulse))")
                                                .font(.caption2)
                                                .foregroundColor(.gray.opacity(0.7))
                                        }

                                        Spacer()

                                        Button {
                                            userToDelete = user
                                            showDeleteConfirmation = true
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                                .padding(8)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    VStack(spacing: 8) {
                        HStack {
                            TextField("Add username...", text: $newUsername)
                                .padding(10)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Done") {
                                            UIApplication.shared.endEditing()
                                        }
                                    }
                                }

                            Button("Add") {
                                let trimmed = newUsername.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !trimmed.isEmpty else { return }

                                WhatPulseAPI.fetchUser(username: trimmed) { user in
                                    DispatchQueue.main.async {
                                        if let user = user {
                                            store.addUser(user)
                                            newUsername = ""
                                            errorMessage = nil
                                        } else {
                                            errorMessage = "User \"\(trimmed)\" not found or has no public data."
                                        }
                                    }
                                }
                            }
                            .disabled(newUsername.isEmpty)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }
                    .padding()
                }
            }

            NavigationLink(
                destination: selectedUser.map { UserDetailView(user: $0) },
                isActive: Binding(
                    get: { selectedUser != nil },
                    set: { isActive in
                        if !isActive {
                            selectedUser = nil
                        }
                    }
                )
            ) {
                EmptyView()
            }
            .hidden()
            .onAppear {
                store.refreshAllUsers()
            }
        }
        // 💬 Löschbestätigung
        .confirmationDialog(
            "Are you sure you want to remove this user?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let user = userToDelete,
                   let index = store.users.firstIndex(where: { $0.accountName == user.accountName }) {
                    store.removeUser(at: index)
                    userToDelete = nil
                }
            }

            Button("Cancel", role: .cancel) {
                userToDelete = nil
            }
        }
    }

    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}
