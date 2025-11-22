//
//  EmergencyView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

struct EmergencyView: View {
    @Environment(\.presentationMode) var presentationMode

    let emergencyStrategies = [
        Strategy(icon: "figure.walk", title: "Take a Walk", description: "Get outside for 10 minutes. Fresh air helps clear your mind.", color: .green),
        Strategy(icon: "phone.fill", title: "Call Someone", description: "Reach out to a trusted friend or family member.", color: .blue),
        Strategy(icon: "book.fill", title: "Read", description: "Open a book or article to redirect your attention.", color: .orange),
        Strategy(icon: "sportscourt.fill", title: "Exercise", description: "Do 20 push-ups or jumping jacks to release energy.", color: .red),
        Strategy(icon: "music.note", title: "Listen to Music", description: "Put on your favorite uplifting playlist.", color: .purple),
        Strategy(icon: "cup.and.saucer.fill", title: "Make a Drink", description: "Prepare tea or coffee. The ritual helps.", color: .brown),
        Strategy(icon: "water.waves", title: "Cold Shower", description: "A quick cold shower can reset your mindset.", color: .cyan),
        Strategy(icon: "brain.head.profile", title: "Meditate", description: "Take 5 minutes to breathe and center yourself.", color: .indigo)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section
                    ZStack {
                        LinearGradient(
                            colors: Color.dangerGradient + [Color.orange.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 100, height: 100)

                                Image(systemName: "heart.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                            }

                            VStack(spacing: 8) {
                                Text("You've Got This")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                Text("This urge will pass. Try one of these strategies:")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.95))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 40)
                    }
                    .cornerRadius(28)
                    .shadow(color: Color.red.opacity(0.3), radius: 20, y: 10)
                    .padding(.horizontal)

                    VStack(spacing: 16) {
                        ForEach(emergencyStrategies) { strategy in
                            StrategyCard(strategy: strategy)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.green.opacity(0.15))
                                    .frame(width: 40, height: 40)

                                Image(systemName: "lightbulb.fill")
                                    .font(.title3)
                                    .foregroundColor(.green)
                            }

                            Text("Remember")
                                .font(.headline)
                                .fontWeight(.semibold)

                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            RememberPoint(text: "Urges peak and then fade")
                            RememberPoint(text: "You've overcome this before")
                            RememberPoint(text: "Every 'no' makes you stronger")
                            RememberPoint(text: "Your future self will thank you")
                        }
                    }
                    .padding(24)
                    .glassCard(cornerRadius: 20)
                    .padding(.horizontal)

                    Button(action: {
                        if let url = URL(string: "https://www.nofap.com/rebooting/") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "link")
                            Text("Visit NoFap Resources")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                colors: Color.primaryGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.blue.opacity(0.3), radius: 15, y: 8)
                    }
                    .scaleButton()
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Need Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct Strategy: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct StrategyCard: View {
    let strategy: Strategy
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.bouncy) {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isPressed = false
                }
            }
        }) {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(strategy.color.opacity(0.15))
                        .frame(width: 48, height: 48)

                    Image(systemName: strategy.icon)
                        .font(.title3)
                        .foregroundColor(strategy.color)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(strategy.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(strategy.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                }

                Spacer()
            }
            .padding(20)
            .glassCard(cornerRadius: 16)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RememberPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.body)

            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            Spacer()
        }
    }
}
