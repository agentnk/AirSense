import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var useCurrentLocation: Bool {
        didSet {
            UserDefaults.standard.set(useCurrentLocation, forKey: Constants.UserDefaults.useCurrentLocation)
        }
    }
    
    @Published var selectedCityId: String {
        didSet {
            UserDefaults.standard.set(selectedCityId, forKey: Constants.UserDefaults.selectedCity)
        }
    }
    
    @Published var airQualityAlerts: Bool {
        didSet {
            UserDefaults.standard.set(airQualityAlerts, forKey: Constants.UserDefaults.airQualityAlerts)
            if airQualityAlerts {
                NotificationService.shared.requestAuthorization()
            }
        }
    }
    
    @Published var appTheme: Int {
        didSet {
            UserDefaults.standard.set(appTheme, forKey: Constants.UserDefaults.appTheme)
        }
    }
    
    let cities = CityLocation.predefinedCities
    
    init() {
        let defaults = UserDefaults.standard
        // Set defaults if not existing
        if defaults.object(forKey: Constants.UserDefaults.useCurrentLocation) == nil {
            defaults.set(true, forKey: Constants.UserDefaults.useCurrentLocation)
        }
        if defaults.object(forKey: Constants.UserDefaults.selectedCity) == nil {
            defaults.set("Colombo", forKey: Constants.UserDefaults.selectedCity)
        }
        if defaults.object(forKey: Constants.UserDefaults.airQualityAlerts) == nil {
            defaults.set(false, forKey: Constants.UserDefaults.airQualityAlerts)
        }
        if defaults.object(forKey: Constants.UserDefaults.appTheme) == nil {
            defaults.set(0, forKey: Constants.UserDefaults.appTheme) // 0: System, 1: Light, 2: Dark
        }
        
        self.useCurrentLocation = defaults.bool(forKey: Constants.UserDefaults.useCurrentLocation)
        self.selectedCityId = defaults.string(forKey: Constants.UserDefaults.selectedCity) ?? "Colombo"
        self.airQualityAlerts = defaults.bool(forKey: Constants.UserDefaults.airQualityAlerts)
        self.appTheme = defaults.integer(forKey: Constants.UserDefaults.appTheme)
    }
}
