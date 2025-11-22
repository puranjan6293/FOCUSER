//
//  BlockedSitesView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI
import SafariServices

struct BlockedSitesView: View {
    @EnvironmentObject var blocklistManager: BlocklistManager
    @EnvironmentObject var statisticsManager: StatisticsManager
    @StateObject private var screenTimeManager = ScreenTimeManager.shared
    @State private var showingAddSite = false
    @State private var newSiteDomain = ""
    @State private var showingEnableInstructions = false
    @State private var showingReloadAlert = false
    @State private var reloadMessage = ""
    @State private var showScreenTimeAuth = false

    var body: some View {
        NavigationView {
            ZStack {
                if blocklistManager.blockedSites.isEmpty {
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 120, height: 120)

                            Image(systemName: "shield.slash.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: Color.primaryGradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .padding(.top, 40)

                        VStack(spacing: 8) {
                            Text("No sites blocked yet")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Add sites to your blocklist to get started")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        Button(action: {
                            showingAddSite = true
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Your First Site")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(height: 54)
                            .frame(maxWidth: 300)
                            .background(
                                LinearGradient(
                                    colors: Color.primaryGradient,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.blue.opacity(0.3), radius: 15, y: 8)
                        }
                        .scaleButton()
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        Section {
                            if screenTimeManager.isAuthorized {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.green.opacity(0.15))
                                                .frame(width: 44, height: 44)

                                            Image(systemName: "checkmark.shield.fill")
                                                .foregroundColor(.green)
                                                .font(.title3)
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Cross-Browser Protection")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                            Text("Active in all browsers")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(.vertical, 8)
                            } else {
                                Button(action: {
                                    showScreenTimeAuth = true
                                }) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.orange.opacity(0.15))
                                                    .frame(width: 44, height: 44)

                                                Image(systemName: "exclamationmark.shield.fill")
                                                    .foregroundColor(.orange)
                                                    .font(.title3)
                                            }

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Enable All-Browser Blocking")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.primary)
                                                Text("Block in Chrome, Firefox, Opera, etc.")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                                .scaleButton()
                            }

                            Button(action: {
                                showingEnableInstructions = true
                            }) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.blue.opacity(0.15))
                                                .frame(width: 44, height: 44)

                                            Image(systemName: "safari")
                                                .foregroundColor(.blue)
                                                .font(.title3)
                                        }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Safari Content Blocker")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                            Text("Extra protection layer")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            .scaleButton()
                        } footer: {
                            if screenTimeManager.isAuthorized {
                                Text("You have the best protection! Sites are blocked in ALL browsers using Screen Time + Safari Content Blocker.")
                                    .font(.caption)
                            } else {
                                Text("Safari-only blocking is active. Enable Screen Time for protection in Chrome, Firefox, and all other browsers.")
                                    .font(.caption)
                            }
                        }

                        Section(header: Text("Blocked Sites (\(blocklistManager.blockedSites.count))").font(.subheadline).fontWeight(.semibold)) {
                            ForEach(blocklistManager.blockedSites.sorted(by: { $0.domain < $1.domain })) { site in
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill((site.isDefault ? Color.blue : Color.green).opacity(0.15))
                                            .frame(width: 36, height: 36)

                                        Image(systemName: "shield.fill")
                                            .foregroundColor(site.isDefault ? .blue : .green)
                                            .font(.system(size: 14))
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(site.domain)
                                            .font(.body)
                                            .fontWeight(.medium)

                                        HStack(spacing: 6) {
                                            if site.isDefault {
                                                Text("Default")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            } else {
                                                Text("Added \(formattedDate(site.dateAdded))")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }

                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteSites)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Blocklist")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddSite = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSite) {
                AddSiteSheet(
                    isPresented: $showingAddSite,
                    newSiteDomain: $newSiteDomain,
                    onAdd: {
                        blocklistManager.addSite(newSiteDomain)
                        blocklistManager.reloadContentBlocker { success, error in
                            DispatchQueue.main.async {
                                if success {
                                    reloadMessage = "Site added! Close Safari tabs and reopen them to apply blocking."
                                } else {
                                    reloadMessage = "Site added but blocker reload failed: \(error ?? "Unknown error")"
                                }
                                showingReloadAlert = true
                            }
                        }
                        newSiteDomain = ""
                    }
                )
            }
            .sheet(isPresented: $showingEnableInstructions) {
                EnableContentBlockerSheet(isPresented: $showingEnableInstructions)
            }
            .alert("Blocklist Updated", isPresented: $showingReloadAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(reloadMessage)
            }
            .sheet(isPresented: $showScreenTimeAuth) {
                ScreenTimeAuthView(isPresented: $showScreenTimeAuth)
            }
        }
    }

    private func deleteSites(at offsets: IndexSet) {
        let sortedSites = blocklistManager.blockedSites.sorted(by: { $0.domain < $1.domain })
        for index in offsets {
            let site = sortedSites[index]
            blocklistManager.removeSite(site)
        }

        blocklistManager.reloadContentBlocker { success, error in
            DispatchQueue.main.async {
                if success {
                    reloadMessage = "Site removed! Close Safari tabs and reopen them to apply changes."
                } else {
                    reloadMessage = "Site removed but blocker reload failed: \(error ?? "Unknown error")"
                }
                showingReloadAlert = true
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct AddSiteSheet: View {
    @Binding var isPresented: Bool
    @Binding var newSiteDomain: String
    let onAdd: () -> Void

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 80, height: 80)

                        Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                            .font(.system(size: 40))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: Color.primaryGradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }

                    VStack(spacing: 8) {
                        Text("Block a New Site")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Add any website you want to block")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Domain Name")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    TextField("example.com", text: $newSiteDomain)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        Text("How to format:")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }

                    Text("• Enter domain without http:// or www.\n• Example: pornhub.com\n• Subdomains work too: m.facebook.com")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)

                Spacer()

                Button(action: {
                    onAdd()
                    isPresented = false
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add to Blocklist")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient(
                            colors: newSiteDomain.isEmpty ? [Color.gray, Color.gray] : Color.primaryGradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: newSiteDomain.isEmpty ? .clear : Color.blue.opacity(0.3), radius: 15, y: 8)
                }
                .scaleButton()
                .disabled(newSiteDomain.isEmpty)
            }
            .padding()
            .navigationTitle("Add Site")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct EnableContentBlockerSheet: View {
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 100, height: 100)

                            Image(systemName: "safari")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: Color.primaryGradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }

                        VStack(spacing: 8) {
                            Text("Safari Content Blocker")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Follow these steps to enable")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top)

                    VStack(alignment: .leading, spacing: 20) {
                        InstructionStep(
                            number: "1",
                            title: "Open Safari Settings",
                            description: "Go to iOS Settings app and scroll to Safari",
                            color: Color.primaryGradient[0]
                        )

                        InstructionStep(
                            number: "2",
                            title: "Tap Extensions",
                            description: "Find and tap on 'Extensions' option",
                            color: Color.primaryGradient[0]
                        )

                        InstructionStep(
                            number: "3",
                            title: "Enable Focuser",
                            description: "Find 'Focuser' and toggle it ON",
                            color: Color.successGradient[0]
                        )

                        InstructionStep(
                            number: "4",
                            title: "You're Protected!",
                            description: "The content blocker is now active in Safari",
                            color: Color.successGradient[0]
                        )
                    }

                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Open Settings")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                colors: Color.primaryGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.blue.opacity(0.3), radius: 15, y: 8)
                    }
                    .scaleButton()
                    .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("Setup Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct InstructionStep: View {
    let number: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)

                Text(number)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineSpacing(2)
            }

            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}
