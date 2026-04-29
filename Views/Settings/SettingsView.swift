import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location Preferences")) {
                    Toggle("Use Current Location", isOn: $viewModel.useCurrentLocation)
                        .tint(Theme.aqiGood)
                    
                    if !viewModel.useCurrentLocation {
                        Picker("Default City", selection: $viewModel.selectedCityId) {
                            ForEach(viewModel.cities) { city in
                                Text(city.name).tag(city.id)
                            }
                        }
                    }
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Air Quality Alerts", isOn: $viewModel.airQualityAlerts)
                        .tint(Theme.aqiGood)
                    Text("Receive alerts when AQI in your selected area exceeds 100.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $viewModel.appTheme) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
