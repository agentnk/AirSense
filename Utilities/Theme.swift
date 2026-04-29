import SwiftUI

struct Theme {
    static let primaryBackground = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    
    // AQI Colors
    static let aqiGood = Color.green
    static let aqiModerate = Color.yellow
    static let aqiUnhealthyForSensitiveGroups = Color.orange
    static let aqiUnhealthy = Color.red
    static let aqiVeryUnhealthy = Color.purple
    static let aqiHazardous = Color(UIColor.brown)
    
    // Shadow
    static let shadowRadius: CGFloat = 8
    static let shadowOpacity: Double = 0.1
    
    // Corner Radius
    static let cardCornerRadius: CGFloat = 16
}
