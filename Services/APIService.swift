import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL provided."
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .decodingError(let error): return "Failed to decode data: \(error.localizedDescription)"
        case .invalidResponse: return "Invalid response from server."
        }
    }
}

protocol APIServiceProtocol {
    func fetchAQI(latitude: Double, longitude: Double) async throws -> AppAQIData
    func fetchAQI(city: String) async throws -> AppAQIData
}

class APIService: APIServiceProtocol {
    static let shared = APIService()
    
    // For this example, we'll return mock data to simulate an API call
    // In a production app, use URLSession to fetch from OpenAQ or similar.
    func fetchAQI(latitude: Double, longitude: Double) async throws -> AppAQIData {
        return try await generateMockData(locationName: "Current Location")
    }
    
    func fetchAQI(city: String) async throws -> AppAQIData {
        return try await generateMockData(locationName: city)
    }
    
    private func generateMockData(locationName: String) async throws -> AppAQIData {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        let mockAQI = Int.random(in: 20...180)
        let pollutants = [
            Pollutant(name: "PM2.5", value: Double.random(in: 5...50), unit: "µg/m³"),
            Pollutant(name: "PM10", value: Double.random(in: 10...80), unit: "µg/m³"),
            Pollutant(name: "NO2", value: Double.random(in: 1...30), unit: "ppb"),
            Pollutant(name: "CO", value: Double.random(in: 0.1...2.0), unit: "ppm")
        ]
        
        return AppAQIData(
            aqiValue: mockAQI,
            category: AQIHelper.getCategory(for: mockAQI),
            locationName: locationName,
            pollutants: pollutants,
            lastUpdated: Date()
        )
    }
}
