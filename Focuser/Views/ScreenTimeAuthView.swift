//
//  ScreenTimeAuthView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

struct ScreenTimeAuthView: View {
    @StateObject private var screenTimeManager = ScreenTimeManager.shared
    @Binding var isPresented: Bool
    @State private var isRequesting = false
    @State private var showError = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.purple.opacity(0.1))
                                .frame(width: 120, height: 120)

                            Image(systemName: "lock.shield.fill")
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
                            Text("Enable Cross-Browser Blocking")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)

                            Text("Block sites in Chrome, Firefox, Opera, and ALL browsers using Apple's Screen Time technology")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 40)

                    VStack(alignment: .leading, spacing: 20) {
                        FeatureItem(
                            icon: "checkmark.shield.fill",
                            color: .green,
                            title: "Works Everywhere",
                            description: "Blocks sites in Safari, Chrome, Firefox, Opera, and all other browsers"
                        )

                        FeatureItem(
                            icon: "lock.fill",
                            color: .blue,
                            title: "System-Level Protection",
                            description: "Uses Apple's built-in parental control technology"
                        )

                        FeatureItem(
                            icon: "hand.raised.fill",
                            color: .orange,
                            title: "Can't Be Bypassed",
                            description: "Protection works across all apps and cannot be disabled without your permission"
                        )

                        FeatureItem(
                            icon: "eye.slash.fill",
                            color: .purple,
                            title: "Private & Secure",
                            description: "All blocking happens on your device. No data is sent anywhere."
                        )
                    }
                    .padding(.horizontal, 24)

                    VStack(spacing: 16) {
                        if isRequesting {
                            VStack(spacing: 16) {
                                ProgressView()
                                    .scaleEffect(1.5)

                                Text("Requesting authorization...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 32)
                        } else {
                            Button(action: requestAuthorization) {
                                HStack(spacing: 12) {
                                    Image(systemName: "shield.checkmark.fill")
                                        .font(.title3)
                                    Text("Enable Protection")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(
                                    LinearGradient(
                                        colors: Color.primaryGradient,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(18)
                                .shadow(color: Color.blue.opacity(0.3), radius: 15, y: 8)
                            }
                            .scaleButton()

                            Button(action: {
                                isPresented = false
                            }) {
                                Text("Maybe Later")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .alert("Authorization Required", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(screenTimeManager.authorizationError ?? "Unable to authorize Screen Time access")
            }
        }
    }

    private func requestAuthorization() {
        isRequesting = true

        Task {
            do {
                try await screenTimeManager.requestAuthorization()
                // Small delay to let the user see success
                try await Task.sleep(nanoseconds: 500_000_000)
                isPresented = false
            } catch {
                showError = true
            }
            isRequesting = false
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let color: Color
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
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

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
