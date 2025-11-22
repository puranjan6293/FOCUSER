//
//  OnboardingView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        systemImage: "shield.fill",
                        title: "Take Control",
                        description: "Block harmful content across Safari and take the first step towards a healthier digital life.",
                        accentColor: .blue
                    )
                    .tag(0)

                    OnboardingPageView(
                        systemImage: "chart.line.uptrend.xyaxis",
                        title: "Track Your Progress",
                        description: "Monitor your streak, see blocked attempts, and celebrate your victories every day.",
                        accentColor: .green
                    )
                    .tag(1)

                    OnboardingPageView(
                        systemImage: "person.2.fill",
                        title: "Build Accountability",
                        description: "Stay motivated with daily reminders and optional accountability features.",
                        accentColor: .orange
                    )
                    .tag(2)

                    OnboardingPageView(
                        systemImage: "checkmark.circle.fill",
                        title: "You've Got This",
                        description: "Join thousands of people reclaiming their time and mental clarity.",
                        accentColor: .purple
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                if currentPage == 3 {
                    Button(action: {
                        withAnimation {
                            isOnboardingComplete = true
                        }
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                } else {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let systemImage: String
    let title: String
    let description: String
    let accentColor: Color

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 100))
                .foregroundColor(accentColor)

            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()
        }
    }
}
