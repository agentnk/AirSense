import Foundation

struct AQIResponse: Codable {
    let meta: MetaData
    let results: [AQIResult]
}

struct MetaData: Codable {
    let name: String
    let found: Int
}

struct AQIResult: Codable {
    let location: String
    let city: String?
    let country: String
    let measurements: [Measurement]
    
    var calculatedAQI: Int {
        // Simplified mock calculation: returning the highest pollutant value as AQI
        // In a real app, this would use proper EPA formulas per pollutant
        let maxVal = measurements.map { $0.value }.max() ?? 0
        return Int(maxVal)
    }
}

struct Measurement: Codable {
    let parameter: String // pm25, pm10, no2, co, o3, so2
    let value: Double
    let lastUpdated: String
    let unit: String
}

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
