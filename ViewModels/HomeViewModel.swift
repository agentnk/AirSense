import Foundation
import Combine
import CoreLocation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var aqiData: AppAQIData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService: APIServiceProtocol
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIServiceProtocol = APIService.shared, locationManager: LocationManager) {
        self.apiService = apiService
        self.locationManager = locationManager
        
        // Listen for location changes if using current location
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] coord in
                let useCurrentLocation = UserDefaults.standard.bool(forKey: Constants.UserDefaults.useCurrentLocation)
                if useCurrentLocation {
                    Task {
                        await self?.fetchData(latitude: coord.latitude, longitude: coord.longitude)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func refreshData() async {
        let useCurrentLocation = UserDefaults.standard.bool(forKey: Constants.UserDefaults.useCurrentLocation)
        if useCurrentLocation, let coord = locationManager.location {
            await fetchData(latitude: coord.latitude, longitude: coord.longitude)
        } else {
            let cityId = UserDefaults.standard.string(forKey: Constants.UserDefaults.selectedCity) ?? "Colombo"
            await fetchData(city: cityId)
        }
    }
    
    private func fetchData(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await apiService.fetchAQI(latitude: latitude, longitude: longitude)
            self.aqiData = data
            checkAlerts(data: data)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func fetchData(city: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await apiService.fetchAQI(city: city)
            self.aqiData = data
            checkAlerts(data: data)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func checkAlerts(data: AppAQIData) {
        let alertsEnabled = UserDefaults.standard.bool(forKey: Constants.UserDefaults.airQualityAlerts)
        if alertsEnabled {
            NotificationService.shared.scheduleAQIAlert(for: data.aqiValue, category: data.category)
        }
    }
}
