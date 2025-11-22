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
                    VStack(spacing: 16) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)

                        Text("You've Got This")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("This urge will pass. Try one of these strategies:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 32)

                    VStack(spacing: 16) {
                        ForEach(emergencyStrategies) { strategy in
                            StrategyCard(strategy: strategy)
                        }
                    }
                    .padding(.horizontal)

                    VStack(spacing: 12) {
                        Text("Remember")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 8) {
                            RememberPoint(text: "Urges peak and then fade")
                            RememberPoint(text: "You've overcome this before")
                            RememberPoint(text: "Every 'no' makes you stronger")
                            RememberPoint(text: "Your future self will thank you")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)

                    Button(action: {
                        if let url = URL(string: "https://www.nofap.com/rebooting/") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label("Visit NoFap Resources", systemImage: "link")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
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

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: strategy.icon)
                .font(.title2)
                .foregroundColor(strategy.color)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(strategy.title)
                    .font(.headline)

                Text(strategy.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct RememberPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
