import SwiftUI

@main
struct AirSenseLankaApp: App {
    @StateObject private var locationManager: LocationManager
    @StateObject private var homeViewModel: HomeViewModel
    @StateObject private var mapViewModel: MapViewModel
    @StateObject private var settingsViewModel: SettingsViewModel
    
    @AppStorage(Constants.UserDefaults.appTheme) private var appTheme = 0
    
    init() {
        let loc = LocationManager()
        let api = APIService()
        let notif = NotificationService()
        
        _locationManager = StateObject(wrappedValue: loc)
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(apiService: api, locationManager: loc, notificationService: notif))
        _mapViewModel = StateObject(wrappedValue: MapViewModel(apiService: api))
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel(notificationService: notif))
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                MapScreen()
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .environmentObject(homeViewModel)
            .environmentObject(mapViewModel)
            .environmentObject(settingsViewModel)
            .preferredColorScheme(colorScheme(for: appTheme))
            .onAppear {
                let useCurrentLocation = UserDefaults.standard.bool(forKey: Constants.UserDefaults.useCurrentLocation)
                if useCurrentLocation {
                    locationManager.requestPermission()
                }
            }
            .tint(Theme.aqiGood)
        }
    }
    
    private func colorScheme(for theme: Int) -> ColorScheme? {
        switch theme {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }
}
