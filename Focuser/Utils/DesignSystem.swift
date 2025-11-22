//
//  DesignSystem.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

// MARK: - Semantic Colors
extension Color {
    // MARK: Background Colors (Adaptive)
    static let backgroundPrimary = Color("BackgroundPrimary", bundle: nil, fallback: Color(light: Color(hex: "F8F9FA"), dark: Color(hex: "000000")))
    static let backgroundSecondary = Color("BackgroundSecondary", bundle: nil, fallback: Color(light: Color(hex: "FFFFFF"), dark: Color(hex: "1C1C1E")))
    static let backgroundTertiary = Color("BackgroundTertiary", bundle: nil, fallback: Color(light: Color(hex: "F2F2F7"), dark: Color(hex: "2C2C2E")))

    // MARK: Surface Colors (Cards & Components)
    static let surfaceElevated = Color("SurfaceElevated", bundle: nil, fallback: Color(light: Color.white.opacity(0.8), dark: Color(hex: "1C1C1E").opacity(0.8)))
    static let surfaceHighlight = Color("SurfaceHighlight", bundle: nil, fallback: Color(light: Color.white, dark: Color(hex: "2C2C2E")))

    // MARK: Text Colors (Adaptive)
    static let textPrimary = Color("TextPrimary", bundle: nil, fallback: Color(light: Color(hex: "1C1C1E"), dark: Color(hex: "FFFFFF")))
    static let textSecondary = Color("TextSecondary", bundle: nil, fallback: Color(light: Color(hex: "3C3C43").opacity(0.6), dark: Color(hex: "EBEBF5").opacity(0.6)))
    static let textTertiary = Color("TextTertiary", bundle: nil, fallback: Color(light: Color(hex: "3C3C43").opacity(0.3), dark: Color(hex: "EBEBF5").opacity(0.3)))

    // MARK: Brand Gradients (Enhanced)
    static let primaryGradient = [Color(hex: "667eea"), Color(hex: "764ba2")]
    static let primaryGradientMesh = [Color(hex: "667eea"), Color(hex: "764ba2"), Color(hex: "8b5fbf")]

    static let successGradient = [Color(hex: "11998e"), Color(hex: "38ef7d")]
    static let successGradientMesh = [Color(hex: "06d6a0"), Color(hex: "11998e"), Color(hex: "38ef7d")]

    static let warningGradient = [Color(hex: "f2994a"), Color(hex: "f2c94c")]
    static let warningGradientMesh = [Color(hex: "f2994a"), Color(hex: "f2c94c"), Color(hex: "ffd93d")]

    static let dangerGradient = [Color(hex: "eb3349"), Color(hex: "f45c43")]
    static let dangerGradientMesh = [Color(hex: "eb3349"), Color(hex: "f45c43"), Color(hex: "ff6b6b")]

    static let coolGradient = [Color(hex: "2193b0"), Color(hex: "6dd5ed")]
    static let coolGradientMesh = [Color(hex: "2193b0"), Color(hex: "6dd5ed"), Color(hex: "89f7fe")]

    static let sunsetGradient = [Color(hex: "ff6b6b"), Color(hex: "feca57")]
    static let sunsetGradientMesh = [Color(hex: "ff6b6b"), Color(hex: "feca57"), Color(hex: "ffd93d")]

    // MARK: New Premium Gradients
    static let oceanGradient = [Color(hex: "667eea"), Color(hex: "64b3f4"), Color(hex: "c2e9fb")]
    static let forestGradient = [Color(hex: "134e5e"), Color(hex: "71b280")]
    static let roseGradient = [Color(hex: "f857a6"), Color(hex: "ff5858")]
    static let auroreGradient = [Color(hex: "a8edea"), Color(hex: "fed6e3")]
    static let twilightGradient = [Color(hex: "360033"), Color(hex: "0b8793")]
    static let peachGradient = [Color(hex: "ED4264"), Color(hex: "FFEDBC")]

    // MARK: Accent Colors
    static let accentBlue = Color(hex: "007AFF")
    static let accentPurple = Color(hex: "AF52DE")
    static let accentGreen = Color(hex: "34C759")
    static let accentOrange = Color(hex: "FF9500")
    static let accentRed = Color(hex: "FF3B30")

    // Helper for adaptive colors
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }

    // Helper for named colors with fallback
    init(_ name: String, bundle: Bundle?, fallback: Color) {
        if let _ = UIColor(named: name) {
            self.init(name)
        } else {
            self = fallback
        }
    }

    // Light/Dark initializer
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography
extension Font {
    // Display Fonts (Hero sections)
    static let displayLarge = Font.system(size: 48, weight: .heavy, design: .rounded)
    static let displayMedium = Font.system(size: 40, weight: .bold, design: .rounded)

    // Title Fonts
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)

    // Body Fonts
    static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyEmphasized = Font.system(size: 17, weight: .medium, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)

    // Supporting Fonts
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)

    // Special Purpose
    static let monospacedDigit = Font.system(size: 17, design: .monospaced)
    static let monospacedLarge = Font.system(size: 28, weight: .bold, design: .monospaced)
}

// MARK: - Spacing
enum Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}

// MARK: - Corner Radius
enum CornerRadius {
    static let xs: CGFloat = 6
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 28
    static let xxxl: CGFloat = 36
    static let full: CGFloat = 9999
}

// MARK: - Shadows
enum Shadows {
    static let small = (color: Color.black.opacity(0.08), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
    static let medium = (color: Color.black.opacity(0.12), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
    static let large = (color: Color.black.opacity(0.16), radius: CGFloat(16), x: CGFloat(0), y: CGFloat(8))
    static let xlarge = (color: Color.black.opacity(0.20), radius: CGFloat(24), x: CGFloat(0), y: CGFloat(12))

    // Colored shadows for depth
    static func colored(_ color: Color, radius: CGFloat = 12, opacity: Double = 0.3) -> (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        (color: color.opacity(opacity), radius: radius, x: 0, y: 6)
    }
}

// MARK: - Animation Presets (Additional)
extension Animation {
    // Note: smooth, bouncy, gentle, snappy are defined in AnimationStyles.swift
    static let silky = Animation.spring(response: 0.5, dampingFraction: 0.9)
    static let energetic = Animation.spring(response: 0.35, dampingFraction: 0.65)

    static func delay(_ delay: Double, animation: Animation = .smooth) -> Animation {
        animation.delay(delay)
    }
}

// MARK: - Haptic Feedback
enum Haptics {
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - View Modifiers

// Enhanced Glass Card with depth
struct EnhancedGlassCard: ViewModifier {
    let cornerRadius: CGFloat
    let padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    // Glass effect
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)

                    // Subtle gradient overlay
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Shadows.medium.color, radius: Shadows.medium.radius, x: Shadows.medium.x, y: Shadows.medium.y)
    }
}

// Premium Gradient Card
struct PremiumGradientCard: ViewModifier {
    let colors: [Color]
    let cornerRadius: CGFloat
    let padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    // Main gradient
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // Shimmer overlay
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.0),
                                    Color.white.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(0.5)
                }
            )
            .shadow(color: Shadows.colored(colors.first ?? .blue).color,
                    radius: Shadows.colored(colors.first ?? .blue).radius,
                    x: Shadows.colored(colors.first ?? .blue).x,
                    y: Shadows.colored(colors.first ?? .blue).y)
    }
}

// Interactive Button Effect
struct InteractiveButton: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(isPressed ? 0.9 : 1.0)
            .animation(.snappy, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            Haptics.light()
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
    }
}

// Note: Shimmer is defined in AnimationStyles.swift

// Floating Card with bounce animation
struct FloatingCard: ViewModifier {
    @State private var isFloating = false

    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -8 : 0)
            .animation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true),
                value: isFloating
            )
            .onAppear {
                isFloating = true
            }
    }
}

// Slide in from bottom animation
struct SlideInModifier: ViewModifier {
    let delay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .offset(y: isVisible ? 0 : 50)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.smooth.delay(delay)) {
                    isVisible = true
                }
            }
    }
}

// Scale in animation
struct ScaleInModifier: ViewModifier {
    let delay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isVisible ? 1 : 0.8)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.bouncy.delay(delay)) {
                    isVisible = true
                }
            }
    }
}

// MARK: - View Extensions
extension View {
    func enhancedGlassCard(cornerRadius: CGFloat = CornerRadius.xl, padding: CGFloat = Spacing.md) -> some View {
        modifier(EnhancedGlassCard(cornerRadius: cornerRadius, padding: padding))
    }

    func premiumGradientCard(colors: [Color], cornerRadius: CGFloat = CornerRadius.xl, padding: CGFloat = Spacing.md) -> some View {
        modifier(PremiumGradientCard(colors: colors, cornerRadius: cornerRadius, padding: padding))
    }

    func interactiveButton() -> some View {
        modifier(InteractiveButton())
    }

    // Note: shimmer() is defined in AnimationStyles.swift

    func floating() -> some View {
        modifier(FloatingCard())
    }

    func slideIn(delay: Double = 0) -> some View {
        modifier(SlideInModifier(delay: delay))
    }

    func scaleIn(delay: Double = 0) -> some View {
        modifier(ScaleInModifier(delay: delay))
    }

    // Gradient text
    func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .mask(self)
    }

    // Card with shadow
    func cardStyle(cornerRadius: CGFloat = CornerRadius.xl) -> some View {
        self
            .background(Color.surfaceHighlight)
            .cornerRadius(cornerRadius)
            .shadow(color: Shadows.medium.color, radius: Shadows.medium.radius, x: Shadows.medium.x, y: Shadows.medium.y)
    }
}
