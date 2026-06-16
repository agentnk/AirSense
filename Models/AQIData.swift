import Foundation

// Internal app representation for Views
struct AppAQIData: Equatable {
    let aqiValue: Int
    let category: AQICategory
    let locationName: String
    let pollutants: [Pollutant]
    let lastUpdated: Date
    
    static func == (lhs: AppAQIData, rhs: AppAQIData) -> Bool {
        return lhs.locationName == rhs.locationName && lhs.aqiValue == rhs.aqiValue
    }
}

struct Pollutant: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let unit: String
}
