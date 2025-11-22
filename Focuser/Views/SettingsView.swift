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
                Section {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 80, height: 80)

                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: Color.primaryGradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }

                        VStack(spacing: 4) {
                            Text("Settings")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Customize your experience")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                Section(header: Text("Preferences").font(.subheadline).fontWeight(.semibold)) {
                    SettingToggleRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        color: .orange,
                        isOn: $settingsManager.settings.enableNotifications
                    )

                    SettingToggleRow(
                        icon: "quote.bubble.fill",
                        title: "Motivational Quotes",
                        color: .purple,
                        isOn: $settingsManager.settings.showMotivationalQuotes
                    )
                }

                Section(header: Text("Support").font(.subheadline).fontWeight(.semibold)) {
                    NavigationLink(destination: AccountabilityView(settingsManager: settingsManager)) {
                        SettingRow(icon: "person.2.fill", title: "Accountability Partner", color: .green)
                    }
                }

                Section(header: Text("App Information").font(.subheadline).fontWeight(.semibold)) {
                    SettingInfoRow(icon: "info.circle", title: "Version", value: "1.0.0", color: .blue)

                    Button(action: {
                        showAbout = true
                    }) {
                        SettingRow(icon: "info.circle.fill", title: "About Focuser", color: .blue)
                    }

                    NavigationLink(destination: DebugView()) {
                        SettingRow(icon: "wrench.and.screwdriver", title: "Debug Info", color: .gray)
                    }
                }

                Section(header: Text("Data").font(.subheadline).fontWeight(.semibold)) {
                    Button(action: {
                        showResetAlert = true
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.red.opacity(0.15))
                                    .frame(width: 36, height: 36)

                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 14))
                            }

                            Text("Reset All Statistics")
                                .foregroundColor(.red)
                                .fontWeight(.medium)

                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.red, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        VStack(spacing: 4) {
                            Text("Made with care")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)

                            Text("Stay strong, stay focused")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
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
        ScrollView {
            VStack(spacing: 28) {
                // Hero Section
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 100, height: 100)

                        Image(systemName: "person.2.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: Color.successGradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }

                    VStack(spacing: 8) {
                        Text("Accountability Partner")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Share your journey with someone you trust")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 32)

                // Input Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Partner Email")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    TextField("partner@example.com", text: Binding(
                        get: { settingsManager.settings.accountabilityPartnerEmail ?? "" },
                        set: { settingsManager.settings.accountabilityPartnerEmail = $0.isEmpty ? nil : $0 }
                    ))
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        Text("Your accountability partner will receive weekly progress updates if you grant permission.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)

                // Benefits Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Why It Helps")
                        .font(.headline)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: 16) {
                        BenefitRow(
                            icon: "checkmark.shield.fill",
                            title: "Extra Accountability",
                            color: .green
                        )

                        BenefitRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Share Your Progress",
                            color: .blue
                        )

                        BenefitRow(
                            icon: "hands.sparkles.fill",
                            title: "Get Support When Needed",
                            color: .purple
                        )
                    }
                }
                .padding(24)
                .glassCard(cornerRadius: 20)
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Accountability")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
            }

            Text(title)
                .font(.body)
                .fontWeight(.medium)

            Spacer()
        }
    }
}

struct AboutView: View {
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Hero Section
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 120, height: 120)

                            Image(systemName: "shield.checkmark.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: Color.primaryGradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }

                        VStack(spacing: 8) {
                            Text("Focuser")
                                .font(.system(size: 38, weight: .bold, design: .rounded))

                            Text("Version 1.0.0")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }

                        Text("Your companion in building a healthier relationship with technology and reclaiming your mental clarity.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 32)

                    // Features
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Features")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            FeatureRow(
                                icon: "shield.fill",
                                title: "Content Blocking",
                                description: "Block harmful sites across all browsers"
                            )

                            Divider()

                            FeatureRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Progress Tracking",
                                description: "Monitor your journey with detailed statistics"
                            )

                            Divider()

                            FeatureRow(
                                icon: "hand.raised.fill",
                                title: "Victory Counter",
                                description: "Track every time you resist an urge"
                            )

                            Divider()

                            FeatureRow(
                                icon: "lock.fill",
                                title: "Privacy First",
                                description: "All data stays on your device"
                            )
                        }
                    }
                    .padding(24)
                    .glassCard(cornerRadius: 20)
                    .padding(.horizontal)

                    // Motivational Message
                    VStack(spacing: 16) {
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.red, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("Remember: Recovery is a journey, not a destination. Every day clean is a victory worth celebrating.")
                            .font(.callout)
                            .fontWeight(.medium)
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .lineSpacing(6)
                            .padding(.horizontal, 32)
                    }
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
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineSpacing(2)
            }
        }
        .padding(.vertical, 4)
    }
}

// Helper components for Settings rows
struct SettingRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
            }

            Text(title)
                .foregroundColor(.primary)
                .fontWeight(.medium)

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct SettingToggleRow: View {
    let icon: String
    let title: String
    let color: Color
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
            }

            Text(title)
                .fontWeight(.medium)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

struct SettingInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
            }

            Text(title)
                .fontWeight(.medium)

            Spacer()

            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
