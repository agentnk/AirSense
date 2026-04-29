import SwiftUI

enum AQICategory: String {
    case good = "Good"
    case moderate = "Moderate"
    case unhealthySensitive = "Unhealthy for Sensitive Groups"
    case unhealthy = "Unhealthy"
    case veryUnhealthy = "Very Unhealthy"
    case hazardous = "Hazardous"
    case unknown = "Unknown"
    
    var color: Color {
        switch self {
        case .good: return Theme.aqiGood
        case .moderate: return Theme.aqiModerate
        case .unhealthySensitive: return Theme.aqiUnhealthyForSensitiveGroups
        case .unhealthy: return Theme.aqiUnhealthy
        case .veryUnhealthy: return Theme.aqiVeryUnhealthy
        case .hazardous: return Theme.aqiHazardous
        case .unknown: return Color.gray
        }
    }
    
    var healthRecommendation: String {
        switch self {
        case .good: return "Air quality is considered satisfactory, and air pollution poses little or no risk."
        case .moderate: return "Air quality is acceptable; however, there may be a moderate health concern for a very small number of people."
        case .unhealthySensitive: return "Members of sensitive groups may experience health effects. The general public is not likely to be affected."
        case .unhealthy: return "Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects."
        case .veryUnhealthy: return "Health warnings of emergency conditions. The entire population is more likely to be affected."
        case .hazardous: return "Health alert: everyone may experience more serious health effects."
        case .unknown: return "Data unavailable."
        }
    }
}

struct AQIHelper {
    static func getCategory(for aqi: Int) -> AQICategory {
        switch aqi {
        case 0...50: return .good
        case 51...100: return .moderate
        case 101...150: return .unhealthySensitive
        case 151...200: return .unhealthy
        case 201...300: return .veryUnhealthy
        case 301...500: return .hazardous
        default: return .unknown
        }
    }
}
