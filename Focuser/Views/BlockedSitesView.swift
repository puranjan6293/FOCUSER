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
                    VStack(spacing: 16) {
                        Image(systemName: "shield.slash.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)

                        Text("No sites blocked yet")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Add sites to your blocklist to get started")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        Button(action: {
                            showingAddSite = true
                        }) {
                            Label("Add Your First Site", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                } else {
                    List {
                        Section {
                            if screenTimeManager.isAuthorized {
                                HStack {
                                    Image(systemName: "checkmark.shield.fill")
                                        .foregroundColor(.green)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Cross-Browser Protection Active")
                                            .foregroundColor(.primary)
                                            .font(.subheadline)
                                        Text("Blocking in all browsers via Screen Time")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            } else {
                                Button(action: {
                                    showScreenTimeAuth = true
                                }) {
                                    HStack {
                                        Image(systemName: "exclamationmark.shield.fill")
                                            .foregroundColor(.orange)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Enable All-Browser Blocking")
                                                .foregroundColor(.primary)
                                                .font(.subheadline)
                                            Text("Tap to block in Chrome, Firefox, Opera, etc.")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }

                            Button(action: {
                                showingEnableInstructions = true
                            }) {
                                HStack {
                                    Image(systemName: "safari")
                                        .foregroundColor(.blue)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Enable Safari Content Blocker")
                                            .foregroundColor(.primary)
                                            .font(.subheadline)
                                        Text("Additional layer of protection")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        } footer: {
                            if screenTimeManager.isAuthorized {
                                Text("✅ You have the best protection! Sites are blocked in ALL browsers using Screen Time + Safari Content Blocker.")
                                    .font(.caption)
                            } else {
                                Text("⚠️ Safari-only blocking is active. Enable Screen Time for protection in Chrome, Firefox, and all other browsers.")
                                    .font(.caption)
                            }
                        }

                        Section(header: Text("Blocked Sites (\(blocklistManager.blockedSites.count))")) {
                            ForEach(blocklistManager.blockedSites.sorted(by: { $0.domain < $1.domain })) { site in
                                HStack {
                                    Image(systemName: "shield.fill")
                                        .foregroundColor(site.isDefault ? .blue : .green)
                                        .font(.caption)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(site.domain)
                                            .font(.body)

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

                                    Spacer()
                                }
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
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Domain Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    TextField("example.com", text: $newSiteDomain)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                }

                Text("Enter the domain without http:// or www.\nExample: pornhub.com")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()
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

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        onAdd()
                        isPresented = false
                    }
                    .disabled(newSiteDomain.isEmpty)
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
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Step 1", systemImage: "1.circle.fill")
                            .font(.headline)
                            .foregroundColor(.blue)

                        Text("Open Safari Settings")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Step 2", systemImage: "2.circle.fill")
                            .font(.headline)
                            .foregroundColor(.blue)

                        Text("Tap on 'Extensions'")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Step 3", systemImage: "3.circle.fill")
                            .font(.headline)
                            .foregroundColor(.blue)

                        Text("Find 'Focuser' and toggle it ON")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Step 4", systemImage: "4.circle.fill")
                            .font(.headline)
                            .foregroundColor(.blue)

                        Text("You're all set! The blocker is now active.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Divider()

                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label("Open Settings", systemImage: "gear")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Enable Content Blocker")
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
