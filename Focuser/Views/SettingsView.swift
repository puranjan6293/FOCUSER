//
//  SettingsView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var statisticsManager: StatisticsManager
    @StateObject private var settingsManager = SettingsManager()
    @State private var showResetAlert = false
    @State private var showAbout = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $settingsManager.settings.enableNotifications) {
                        Label("Notifications", systemImage: "bell.fill")
                    }

                    Toggle(isOn: $settingsManager.settings.showMotivationalQuotes) {
                        Label("Motivational Quotes", systemImage: "quote.bubble.fill")
                    }
                }

                Section(header: Text("Accountability")) {
                    NavigationLink(destination: AccountabilityView(settingsManager: settingsManager)) {
                        Label("Accountability Partner", systemImage: "person.2.fill")
                    }
                }

                Section(header: Text("App Information")) {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    Button(action: {
                        showAbout = true
                    }) {
                        Label("About Focuser", systemImage: "info.circle.fill")
                    }

                    NavigationLink(destination: DebugView()) {
                        Label("Debug Info", systemImage: "wrench.and.screwdriver")
                    }
                }

                Section(header: Text("Data")) {
                    Button(action: {
                        showResetAlert = true
                    }) {
                        Label("Reset All Statistics", systemImage: "trash.fill")
                            .foregroundColor(.red)
                    }
                }

                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text("Made with care")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text("Stay strong, stay focused")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .alert("Reset Statistics", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    statisticsManager.resetStatistics()
                }
            } message: {
                Text("Are you sure you want to reset all your statistics? This action cannot be undone.")
            }
            .sheet(isPresented: $showAbout) {
                AboutView(isPresented: $showAbout)
            }
            .onChange(of: settingsManager.settings) { oldValue, newValue in
                settingsManager.updateSettings(newValue)
            }
        }
    }
}

struct AccountabilityView: View {
    @ObservedObject var settingsManager: SettingsManager

    var body: some View {
        Form {
            Section(header: Text("Partner Email")) {
                TextField("partner@example.com", text: Binding(
                    get: { settingsManager.settings.accountabilityPartnerEmail ?? "" },
                    set: { settingsManager.settings.accountabilityPartnerEmail = $0.isEmpty ? nil : $0 }
                ))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            }

            Section {
                Text("Your accountability partner will receive weekly progress updates if you grant permission.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Accountability")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "shield.checkmark.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.top, 40)

                    VStack(spacing: 8) {
                        Text("Focuser")
                            .font(.system(size: 36, weight: .bold))

                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Text("Your companion in building a healthier relationship with technology and reclaiming your mental clarity.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 32)

                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "shield.fill", title: "Content Blocking", description: "Block harmful sites across Safari")

                        FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Progress Tracking", description: "Monitor your journey with detailed statistics")

                        FeatureRow(icon: "flame.fill", title: "Streak System", description: "Stay motivated with daily streaks")

                        FeatureRow(icon: "lock.fill", title: "Privacy First", description: "All data stays on your device")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)

                    Text("Remember: Recovery is a journey, not a destination. Every day clean is a victory worth celebrating.")
                        .font(.footnote)
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 40)
                }
            }
            .navigationTitle("About")
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

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
