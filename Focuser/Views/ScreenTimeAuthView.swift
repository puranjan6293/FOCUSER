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
                    VStack(spacing: 16) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("Enable Cross-Browser Blocking")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        Text("Block sites in Chrome, Firefox, Opera, and ALL browsers using Apple's Screen Time technology")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
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
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()
                        } else {
                            Button(action: requestAuthorization) {
                                HStack {
                                    Image(systemName: "shield.checkmark.fill")
                                    Text("Enable Protection")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                            }

                            Button(action: {
                                isPresented = false
                            }) {
                                Text("Maybe Later")
                                    .font(.subheadline)
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
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
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
