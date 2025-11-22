//
//  AnimationStyles.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

// MARK: - Animation Presets
extension Animation {
    static let smooth = Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)
    static let gentle = Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
    static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)
}

// MARK: - Custom View Modifiers
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.bouncy, value: configuration.isPressed)
    }
}

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
    }
}

struct GradientCard: ViewModifier {
    var colors: [Color]
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: colors.first?.opacity(0.3) ?? .clear, radius: 15, x: 0, y: 8)
            )
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius))
    }

    func gradientCard(colors: [Color], cornerRadius: CGFloat = 20) -> some View {
        modifier(GradientCard(colors: colors, cornerRadius: cornerRadius))
    }

    func scaleButton() -> some View {
        buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Animated Progress Ring
struct AnimatedProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let gradient: [Color]
    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: gradient,
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.smooth.delay(0.2), value: animatedProgress)
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) {
            withAnimation(.smooth) {
                animatedProgress = progress
            }
        }
    }
}

// MARK: - Shimmer Effect
struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .white.opacity(0.3),
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + phase * geometry.size.width * 2)
                }
                .allowsHitTesting(false)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(Shimmer())
    }
}
