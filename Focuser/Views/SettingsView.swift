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
                    Toggle("Notifications", isOn: $settingsManager.settings.enableNotifications)
                    Toggle("Motivational Quotes", isOn: $settingsManager.settings.showMotivationalQuotes)
                }

                Section(header: Text("Support")) {
                    NavigationLink(destination: AccountabilityView(settingsManager: settingsManager)) {
                        Text("Accountability Partner")
                    }
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    Button(action: {
                        showAbout = true
                    }) {
                        Text("About Focuser")
                    }
                }

                Section {
                    Button(role: .destructive, action: {
                        showResetAlert = true
                    }) {
                        Text("Reset All Statistics")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Statistics", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    statisticsManager.resetStatistics()
                }
            } message: {
                Text("This will permanently delete all your progress data. This action cannot be undone.")
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }
}

// Clean About view
struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(spacing: 16) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 56))
                            .foregroundColor(.blue)

                        VStack(spacing: 8) {
                            Text("Focuser")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Version 1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }

                Section(header: Text("Features")) {
                    FeatureRow(icon: "shield.fill", title: "Content Blocking", description: "Block distracting websites")
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Progress Tracking", description: "Monitor your journey")
                    FeatureRow(icon: "hand.raised.fill", title: "Victory Counter", description: "Celebrate each win")
                    FeatureRow(icon: "lock.fill", title: "Privacy First", description: "All data stays on device")
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mission")
                            .font(.headline)

                        Text("Focuser helps you take control of your digital life by blocking distracting websites and tracking your progress.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
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
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
                .frame(width: 32)

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

// Clean Accountability view
struct AccountabilityView: View {
    @ObservedObject var settingsManager: SettingsManager

    var body: some View {
        List {
            Section {
                TextField("Partner's Email", text: Binding(
                    get: { settingsManager.settings.accountabilityPartnerEmail ?? "" },
                    set: { settingsManager.settings.accountabilityPartnerEmail = $0.isEmpty ? nil : $0 }
                ))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            } header: {
                Text("Email Address")
            } footer: {
                Text("Your accountability partner will receive weekly progress updates")
            }

            Section(header: Text("Why It Helps")) {
                BenefitRow(icon: "person.2.fill", title: "Extra Accountability", color: .blue)
                BenefitRow(icon: "chart.bar.fill", title: "Share Your Progress", color: .green)
                BenefitRow(icon: "heart.fill", title: "Get Support", color: .red)
            }
        }
        .navigationTitle("Accountability Partner")
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.body)
                .frame(width: 24)

            Text(title)
                .font(.body)
        }
    }
}

// Legacy support components
struct SettingRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.body)

            Text(title)
        }
    }
}

struct SettingToggleRow: View {
    let icon: String
    let title: String
    let color: Color
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
    }
}

struct SettingInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
