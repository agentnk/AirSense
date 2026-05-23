import Foundation

struct Constants {
    struct UserDefaults {
        static let selectedCity = "selectedCityId"
        static let useCurrentLocation = "useCurrentLocation"
        static let airQualityAlerts = "airQualityAlerts"
        static let appTheme = "appTheme"
    }
    
    // Using a mock open AQ API URL pattern or similar
    static let openAQBaseURL = "https://api.openaq.org/v2"
    
    struct Strings {
        static let appName = "AirSense Lanka"
        static let aqiTitle = "Air Quality Index"
        static let lastUpdated = "Last updated: %@"
        static let pollutantBreakdown = "Pollutant Breakdown"
        static let updatingData = "Updating Data..."
        static let initializing = "Initializing..."
        static let failedToLoad = "Failed to load data"
        static let tryAgain = "Try Again"
    }
}
