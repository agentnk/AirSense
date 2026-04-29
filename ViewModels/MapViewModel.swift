import Foundation
import CoreLocation
import MapKit

@MainActor
class MapViewModel: ObservableObject {
    @Published var cities: [CityLocation] = CityLocation.predefinedCities
    @Published var cityAQIData: [String: AppAQIData] = [:]
    @Published var selectedCity: CityLocation?
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchAllCityData() async {
        for city in cities {
            if cityAQIData[city.name] == nil {
                do {
                    let data = try await apiService.fetchAQI(city: city.name)
                    cityAQIData[city.name] = data
                } catch {
                    print("Failed to fetch data for \(city.name): \(error)")
                }
            }
        }
    }
    
    func colorForCity(_ name: String) -> SwiftUI.Color {
        guard let data = cityAQIData[name] else {
            return Theme.textSecondary
        }
        return data.category.color
    }
    
    func aqiForCity(_ name: String) -> String {
        guard let data = cityAQIData[name] else {
            return "--"
        }
        return "\(data.aqiValue)"
    }
}
