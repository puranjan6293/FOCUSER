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
    var body: some View {
        NavigationView {
            ZStack {
                if blocklistManager.blockedSites.isEmpty {
                    // Clean empty state
                    VStack(spacing: 24) {
                        Spacer()

                        Image(systemName: "shield.lefthalf.filled")
                            .font(.system(size: 64))
                            .foregroundColor(.blue)

                        VStack(spacing: 8) {
                            Text("No Sites Blocked")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("Add websites to protect yourself")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }

                        Button(action: {
                            showingAddSite = true
                        }) {
                            Text("Add Site")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 52)
                                .background(Color.blue)
                                .cornerRadius(16)
                        }
                        .scaleButton()

                        Spacer()
                    }
                } else {
                    List {
                        // Protection settings - simple toggle
                        Section {
                            Toggle(isOn: Binding(
                                get: { screenTimeManager.isAuthorized },
                                set: { newValue in
                                    if newValue {
                                        Task {
                                            try? await screenTimeManager.requestAuthorization()
                                        }
                                    }
                                }
                            )) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("All-Browser Blocking")
                                        .font(.body)

                                    Text("Blocks sites in Chrome, Firefox, etc.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        } footer: {
                            if screenTimeManager.isAuthorized {
                                Text("Cross-browser protection is active")
                            }
                        }

                        // Safari extension setup
                        Section {
                            Button(action: {
                                showingEnableInstructions = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Enable Extension for Safari")
                                            .font(.body)
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
                        } footer: {
                            Text("Follow the setup guide to enable content blocking in Safari")
                        }

                        Section(header: Text("Blocked Sites")) {
                            ForEach(blocklistManager.blockedSites.sorted(by: { $0.domain < $1.domain })) { site in
                                HStack(spacing: 12) {
                                    Image(systemName: "shield.fill")
                                        .foregroundColor(site.isDefault ? .blue : .green)
                                        .font(.body)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(site.domain)
                                            .font(.body)

                                        if !site.isDefault {
                                            Text("Added \(formattedDate(site.dateAdded))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteSites)
                        }
                    }
                    .listStyle(.insetGrouped)
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
                                    reloadMessage = "Site added successfully"
                                    Haptics.success()
                                } else {
                                    reloadMessage = "Site added but reload failed: \(error ?? "Unknown")"
                                    Haptics.error()
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
            .alert("Success", isPresented: $showingReloadAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(reloadMessage)
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
                    reloadMessage = "Site removed successfully"
                    Haptics.success()
                } else {
                    reloadMessage = "Site removed but reload failed: \(error ?? "Unknown")"
                    Haptics.error()
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

// Clean, minimal add sheet
struct AddSiteSheet: View {
    @Binding var isPresented: Bool
    @Binding var newSiteDomain: String
    let onAdd: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("example.com", text: $newSiteDomain)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                } header: {
                    Text("Domain")
                } footer: {
                    Text("Enter domain without http:// or www.\nExample: pornhub.com")
                }
            }
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
            List {
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Text("1")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .frame(width: 36, height: 36)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())

                            Text("Open Settings → Safari → Extensions")
                                .font(.body)
                        }

                        HStack(spacing: 12) {
                            Text("2")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .frame(width: 36, height: 36)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())

                            Text("Toggle Focuser ON")
                                .font(.body)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section {
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Open Settings")
                        }
                    }
                }
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
        HStack(spacing: 12) {
            Text(number)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
