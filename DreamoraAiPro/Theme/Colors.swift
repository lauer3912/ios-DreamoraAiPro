import SwiftUI

extension Color {
    static let appBackground = Color(hex: "0B0F1A")
    static let backgroundSecondary = Color(hex: "151B2E")
    static let surface = Color(hex: "1E293B")
    static let accentPrimary = Color(hex: "8B5CF6")
    static let accentSecondary = Color(hex: "06B6D4")
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "94A3B8")
    static let success = Color(hex: "10B981")
    static let warning = Color(hex: "F59E0B")
    static let error = Color(hex: "EF4444")
    static let moodPeaceful = Color(hex: "10B981")
    static let moodAnxious = Color(hex: "F59E0B")
    static let moodExcited = Color(hex: "8B5CF6")
    static let moodNeutral = Color(hex: "94A3B8")
    static let moodSad = Color(hex: "3B82F6")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct AppGradient {
    static let primary = LinearGradient(
        colors: [Color.accentPrimary, Color.accentSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentDiagonal = LinearGradient(
        colors: [Color(hex: "8B5CF6"), Color(hex: "06B6D4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let moodRing = LinearGradient(
        colors: [Color.accentPrimary, Color.accentSecondary, Color.moodPeaceful],
        startPoint: .top,
        endPoint: .bottom
    )
}

struct AppShadow {
    static func card() -> some View {
        Color.black.opacity(0.3)
    }
}