import SwiftUI

@main
struct AirSenseLankaApp: App {
    @StateObject private var locationManager = LocationManager()
    @AppStorage(Constants.UserDefaults.appTheme) private var appTheme = 0
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView(locationManager: locationManager)
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
            .preferredColorScheme(colorScheme(for: appTheme))
            .onAppear {
                // Request location permissions on first launch if useCurrentLocation is enabled
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
        default: return nil // System default
        }
    }
}
