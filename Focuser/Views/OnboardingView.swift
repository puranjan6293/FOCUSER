//
//  OnboardingView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var currentPage = 0
    @State private var firstWatchDate = Date()
    @State private var dailyFrequency: Int = 1
    @State private var selectedFocusLevel: FocusLevel = .moderate
    @State private var selectedUrgeFrequency: UrgeFrequency = .moderate
    @State private var selectedResistanceRate: ResistanceRate = .sometimes

    var totalPages: Int { 7 }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress indicator at top
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(currentPage >= index ? Color.blue : Color.gray.opacity(0.3))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Content
                TabView(selection: $currentPage) {
                    WelcomePage()
                        .tag(0)

                    FirstTimePage(selectedDate: $firstWatchDate)
                        .tag(1)

                    FrequencyPage(frequency: $dailyFrequency)
                        .tag(2)

                    FocusLevelPage(focusLevel: $selectedFocusLevel)
                        .tag(3)

                    UrgeFrequencyPage(urgeFrequency: $selectedUrgeFrequency)
                        .tag(4)

                    ResistanceRatePage(resistanceRate: $selectedResistanceRate)
                        .tag(5)

                    FinalMotivationPage()
                        .tag(6)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Continue button at bottom
                Button(action: {
                    if currentPage == totalPages - 1 {
                        completeOnboarding()
                    } else {
                        withAnimation(.spring(response: 0.3)) {
                            currentPage += 1
                        }
                    }
                }) {
                    Text(currentPage == totalPages - 1 ? "Let's Go" : "Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .scaleButton()
            }
        }
    }

    private func completeOnboarding() {
        var updatedSettings = settingsManager.settings
        updatedSettings.firstWatchDate = firstWatchDate
        updatedSettings.dailyWatchFrequency = dailyFrequency
        updatedSettings.focusLevel = selectedFocusLevel
        updatedSettings.urgeFrequency = selectedUrgeFrequency
        updatedSettings.resistanceRate = selectedResistanceRate
        updatedSettings.journeyStartDate = Date()
        updatedSettings.hasCompletedOnboarding = true

        settingsManager.updateSettings(updatedSettings)

        withAnimation(.smooth) {
            isOnboardingComplete = true
        }
    }
}

// MARK: - Welcome Page
struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "shield.lefthalf.filled")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 16) {
                Text("Welcome to Focuser")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)

                Text("Let's understand your journey to help you better")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()
            Spacer()
        }
    }
}

// MARK: - First Time Page
struct FirstTimePage: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("When did you first watch porn?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)

                    Text("This helps us understand your journey")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 32)

                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(.horizontal, 16)
            }

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Frequency Page
struct FrequencyPage: View {
    @Binding var frequency: Int

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("How often do you watch?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("Be honest with yourself")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 24) {
                    Text("\(frequency)")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.blue)

                    Text(frequency == 1 ? "time per day" : "times per day")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    VStack(spacing: 16) {
                        Slider(value: Binding(
                            get: { Double(frequency) },
                            set: { frequency = Int($0) }
                        ), in: 0...10, step: 1)
                            .tint(.blue)

                        HStack {
                            Text("0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("10+")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 32)
                }
            }
            .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Focus Level Page
struct FocusLevelPage: View {
    @Binding var focusLevel: FocusLevel

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("How's your focus?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("When you try to work or study")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            .padding(.horizontal, 32)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(FocusLevel.allCases, id: \.self) { level in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                focusLevel = level
                                Haptics.selection()
                            }
                        }) {
                            HStack {
                                Text(level.rawValue)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Spacer()

                                if focusLevel == level {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(focusLevel == level ? Color.blue.opacity(0.1) : Color(.systemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(focusLevel == level ? Color.blue : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
        }
    }
}

// MARK: - Urge Frequency Page
struct UrgeFrequencyPage: View {
    @Binding var urgeFrequency: UrgeFrequency

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("How often do urges come?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("When you're alone or feeling lazy")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            .padding(.horizontal, 32)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(UrgeFrequency.allCases, id: \.self) { freq in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                urgeFrequency = freq
                                Haptics.selection()
                            }
                        }) {
                            HStack {
                                Text(freq.rawValue)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Spacer()

                                if urgeFrequency == freq {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(urgeFrequency == freq ? Color.blue.opacity(0.1) : Color(.systemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(urgeFrequency == freq ? Color.blue : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
        }
    }
}

// MARK: - Resistance Rate Page
struct ResistanceRatePage: View {
    @Binding var resistanceRate: ResistanceRate

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("How often do you resist?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("When urges come, do you resist them?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            .padding(.horizontal, 32)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(ResistanceRate.allCases, id: \.self) { rate in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                resistanceRate = rate
                                Haptics.selection()
                            }
                        }) {
                            HStack {
                                Text(rate.rawValue)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Spacer()

                                if resistanceRate == rate {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(resistanceRate == rate ? Color.blue.opacity(0.1) : Color(.systemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(resistanceRate == rate ? Color.blue : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
        }
    }
}

// MARK: - Final Motivation Page
struct FinalMotivationPage: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "flame.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 20) {
                Text("You're Not Alone")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)

                VStack(spacing: 12) {
                    Text("Thank you for being honest.")
                        .font(.title3)
                        .foregroundColor(.primary)

                    Text("We're here with you every step of the way. Let's fight together. Let's regain confidence. Let's reclaim focus.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
                .padding(.horizontal, 32)
            }

            Spacer()
            Spacer()
        }
    }
}
