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
    @Namespace private var animation

    let pages: [(icon: String, title: String, description: String, gradient: [Color])] = [
        ("shield.checkered", "Take Control", "Block harmful content across all browsers and reclaim your digital wellbeing.", Color.primaryGradient),
        ("chart.line.uptrend.xyaxis.circle.fill", "Track Progress", "Visualize your journey with beautiful stats, streaks, and milestone celebrations.", Color.successGradient),
        ("sparkles", "Stay Motivated", "Daily inspiration, accountability features, and emergency support when you need it.", Color.warningGradient),
        ("hands.clap.fill", "You've Got This", "Join thousands of people transforming their lives, one day at a time.", Color.coolGradient)
    ]

    var body: some View {
        ZStack {
            // Animated background gradient
            LinearGradient(
                colors: pages[currentPage].gradient + [Color.black.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.smooth, value: currentPage)

            VStack(spacing: 0) {
                // Pages
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            systemImage: pages[index].icon,
                            title: pages[index].title,
                            description: pages[index].description,
                            gradient: pages[index].gradient,
                            pageIndex: index
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Custom Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: currentPage == index ? 24 : 8, height: 8)
                            .animation(.smooth, value: currentPage)
                    }
                }
                .padding(.bottom, Spacing.lg)

                // Button
                Button(action: {
                    if currentPage == pages.count - 1 {
                        withAnimation(.smooth) {
                            isOnboardingComplete = true
                        }
                    } else {
                        withAnimation(.smooth) {
                            currentPage += 1
                        }
                    }
                }) {
                    HStack(spacing: 12) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.headline)

                        Image(systemName: currentPage == pages.count - 1 ? "checkmark" : "arrow.right")
                            .font(.headline)
                    }
                    .foregroundColor(pages[currentPage].gradient.first ?? .blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        Capsule()
                            .fill(.white)
                            .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
                    )
                }
                .scaleButton()
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xxl)

                if currentPage < pages.count - 1 {
                    Button("Skip") {
                        withAnimation(.smooth) {
                            currentPage = pages.count - 1
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, Spacing.lg)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let systemImage: String
    let title: String
    let description: String
    let gradient: [Color]
    let pageIndex: Int

    @State private var isAnimated = false

    var body: some View {
        VStack(spacing: Spacing.xxl) {
            Spacer()

            // Icon with animated background
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .blur(radius: 20)
                    .scaleEffect(isAnimated ? 1.1 : 0.9)
                    .animation(.smooth.repeatForever(autoreverses: true).delay(Double(pageIndex) * 0.2), value: isAnimated)

                Circle()
                    .fill(.white.opacity(0.15))
                    .frame(width: 160, height: 160)
                    .blur(radius: 10)

                Image(systemName: systemImage)
                    .font(.system(size: 80, weight: .medium))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
            }
            .padding(.top, Spacing.xxl)

            // Content
            VStack(spacing: Spacing.lg) {
                Text(title)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.1), radius: 5, y: 2)

                Text(description)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.95))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, Spacing.xl)
                    .shadow(color: .black.opacity(0.1), radius: 3, y: 1)
            }

            Spacer()
        }
        .onAppear {
            isAnimated = true
        }
    }
}
