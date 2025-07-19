//
//  ThemeManager.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import Foundation

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
}

// MARK: - iOS Native Colors
struct IOSColors {
    // System colors that adapt to dark/light mode
    static let systemBlue = Color(.systemBlue)
    static let systemGreen = Color(.systemGreen)
    static let systemRed = Color(.systemRed)
    static let systemOrange = Color(.systemOrange)
    static let systemPurple = Color(.systemPurple)
    static let systemIndigo = Color(.systemIndigo)
    
    // Background colors
    static let primaryBackground = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    static let groupedBackground = Color(.systemGroupedBackground)
    
    // Label colors
    static let primaryLabel = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
    static let tertiaryLabel = Color(.tertiaryLabel)
    
    // Fill colors for cards
    static func cardFill(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    static func groupedCardFill(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(.tertiarySystemBackground) : Color(.secondarySystemBackground)
    }
}

// MARK: - iOS Card Style
struct IOSCardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(IOSColors.cardFill(for: colorScheme))
            .cornerRadius(12)
            .shadow(
                color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.05),
                radius: 4,
                x: 0,
                y: 2
            )
    }
}

// MARK: - iOS Grouped Card Style
struct IOSGroupedCardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(IOSColors.groupedCardFill(for: colorScheme))
            .cornerRadius(10)
    }
}

// MARK: - JKT48 Brand Colors
struct JKT48Colors {
    // Primary brand colors
    static let primaryPink = Color(red: 0.92, green: 0.15, blue: 0.45)
    static let lightPink = Color(red: 0.98, green: 0.85, blue: 0.90)
    static let darkPink = Color(red: 0.75, green: 0.10, blue: 0.35)
    
    // System colors with JKT48 theme
    static let systemBlue = Color(.systemBlue)
    static let systemGreen = Color(.systemGreen)
    static let systemRed = Color(.systemRed)
    static let systemOrange = Color(.systemOrange)
    static let systemPurple = Color(.systemPurple)
    static let systemIndigo = Color(.systemIndigo)
    
    // Background colors that adapt to dark/light mode
    static let primaryBackground = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    static let groupedBackground = Color(.systemGroupedBackground)
    
    // Label colors that adapt to dark/light mode
    static let primaryLabel = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
    static let tertiaryLabel = Color(.tertiaryLabel)
    
    // Gradients
    static let pinkGradient = LinearGradient(
        colors: [primaryPink, darkPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let lightPinkGradient = LinearGradient(
        colors: [lightPink, primaryPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Card backgrounds that adapt to color scheme
    static func cardBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    static func cardBackgroundSecondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(.tertiarySystemBackground) : Color(.secondarySystemBackground)
    }
}

// MARK: - Modern Card Styles
struct ModernCardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    init(cornerRadius: CGFloat = 20, shadowRadius: CGFloat = 15) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(JKT48Colors.cardBackground(for: colorScheme))
                    .shadow(
                        color: colorScheme == .dark ? Color.clear : JKT48Colors.primaryPink.opacity(0.1),
                        radius: shadowRadius,
                        x: 0,
                        y: shadowRadius/2
                    )
            )
    }
}

struct GlassmorphismStyle: ViewModifier {
    let tintColor: Color
    let opacity: Double
    
    init(tintColor: Color = .white, opacity: Double = 0.2) {
        self.tintColor = tintColor
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(tintColor.opacity(opacity))
                    .background(.ultraThinMaterial)
            )
    }
}

// MARK: - JKT48 Card Style
struct JKT48CardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(JKT48Colors.cardBackground(for: colorScheme))
                    .shadow(
                        color: colorScheme == .dark ? Color.clear : JKT48Colors.primaryPink.opacity(0.08),
                        radius: 12,
                        x: 0,
                        y: 4
                    )
            )
    }
}

// MARK: - Message Bubble Style
struct MessageBubbleStyle: ViewModifier {
    let isFromUser: Bool
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isFromUser ? JKT48Colors.primaryPink : JKT48Colors.cardBackground(for: colorScheme))
            )
            .foregroundColor(isFromUser ? .white : JKT48Colors.primaryLabel)
            .font(.body)
    }
}

extension View {
    func iOSCard() -> some View {
        modifier(IOSCardStyle())
    }
    
    func iOSGroupedCard() -> some View {
        modifier(IOSGroupedCardStyle())
    }
    
    func modernCard(cornerRadius: CGFloat = 20, shadowRadius: CGFloat = 15) -> some View {
        modifier(ModernCardStyle(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
    
    func glassmorphism(tintColor: Color = .white, opacity: Double = 0.2) -> some View {
        modifier(GlassmorphismStyle(tintColor: tintColor, opacity: opacity))
    }
    
    func jkt48Card() -> some View {
        modifier(JKT48CardStyle())
    }
    
    func messageBubble(isFromUser: Bool) -> some View {
        modifier(MessageBubbleStyle(isFromUser: isFromUser))
    }
    
    // Press event handling for buttons
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        self.modifier(PressEventsModifier(onPress: onPress, onRelease: onRelease))
    }
}

// MARK: - Press Events Modifier
struct PressEventsModifier: ViewModifier {
    let onPress: () -> Void
    let onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in onRelease() }
            )
    }
}
