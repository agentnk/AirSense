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
}
