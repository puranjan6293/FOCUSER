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
        Strategy(icon: "figure.walk", title: "Take a Walk", description: "Get outside for 10 minutes", color: .green),
        Strategy(icon: "phone.fill", title: "Call Someone", description: "Reach out to a friend", color: .blue),
        Strategy(icon: "book.fill", title: "Read", description: "Redirect your attention", color: .orange),
        Strategy(icon: "sportscourt.fill", title: "Exercise", description: "Physical activity helps", color: .red),
        Strategy(icon: "music.note", title: "Listen to Music", description: "Uplifting playlist", color: .purple),
        Strategy(icon: "cup.and.saucer.fill", title: "Make a Drink", description: "Tea or coffee ritual", color: .brown),
        Strategy(icon: "water.waves", title: "Cold Shower", description: "Reset your mindset", color: .cyan),
        Strategy(icon: "brain.head.profile", title: "Meditate", description: "5 minutes of breathing", color: .indigo)
    ]

    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 56))
                            .foregroundColor(.red)

                        Text("You've Got This")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("This urge will pass. Try one of these:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }

                Section(header: Text("Strategies")) {
                    ForEach(emergencyStrategies) { strategy in
                        HStack(spacing: 12) {
                            Image(systemName: strategy.icon)
                                .foregroundColor(strategy.color)
                                .font(.title3)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(strategy.title)
                                    .font(.body)
                                    .fontWeight(.medium)

                                Text(strategy.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Remember")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 8) {
                            RememberPoint(text: "Urges peak and then fade")
                            RememberPoint(text: "You've overcome this before")
                            RememberPoint(text: "Every 'no' makes you stronger")
                            RememberPoint(text: "Your future self will thank you")
                        }
                    }
                    .padding(.vertical, 8)
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

struct RememberPoint: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)

            Text(text)
                .font(.subheadline)
        }
    }
}

struct StrategyCard: View {
    let strategy: Strategy

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: strategy.icon)
                .foregroundColor(strategy.color)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text(strategy.title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(strategy.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
