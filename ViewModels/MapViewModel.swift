import Foundation
import CoreLocation
import MapKit
import Combine
import SwiftUI

@MainActor
class MapViewModel: ObservableObject {
    @Published var cities: [CityLocation] = CityManager.shared.getCities()
    @Published var cityAQIData: [String: AppAQIData] = [:]
    @Published var selectedCity: CityLocation?
    
    @Published var searchQuery = ""
    @Published var searchResults: [SearchResultItem] = []
    @Published var isSearching = false
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0)
    )
    
    private let apiService: APIServiceProtocol
    private let searchService = LocationSearchService()
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        
        // Listen to search query changes with a debounce to minimize API calls
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                Task {
                    await self.performSearch(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    func refreshCities() {
        self.cities = CityManager.shared.getCities()
    }
    
    private func performSearch(query: String) async {
        await searchService.search(query: query)
        self.searchResults = searchService.searchResults
        self.isSearching = searchService.isSearching
    }
    
    func selectSearchResult(_ item: SearchResultItem) {
        let newCity = CityLocation(name: item.name, latitude: item.latitude, longitude: item.longitude)
        CityManager.shared.addCity(newCity)
        refreshCities()
        
        selectedCity = newCity
        region = MKCoordinateRegion(
            center: item.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        
        // Fetch data for the newly added city
        Task {
            do {
                let data = try await apiService.fetchAQI(city: item.name)
                self.cityAQIData[item.name] = data
            } catch {
                print("Failed to fetch data for \(item.name): \(error)")
            }
        }
        
        // Clear search
        searchQuery = ""
        searchResults = []
    }
    
    func fetchAllCityData() async {
        // Always refresh list of cities first to fetch data for newly added ones
        refreshCities()
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

