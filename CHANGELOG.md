# Changelog

All notable changes to the AirSense Lanka project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2026-06-16

### Changed
- Refactored codebase for cleaner architecture and optimization.

### Removed
- Unused `APIError` enum from `APIService`.
- Unused JSON parsing structs (`AQIResponse`, `MetaData`, etc.) from `AQIData` model.
- Unused properties (`openAQBaseURL`, `aqiTitle`) from `Constants`.
- Unused `textPrimary` color from `Theme`.

## [1.1.0] - 2026-05-23

### Added
- **Location Search**: Users can now search for any town or city across Sri Lanka on both the Map and Home screens.
- **Sleek Map Search**: Added a floating search bar and suggestion dropdown overlay on the Map screen with automatic centering, zooming, and card transitions.
- **Home Search Sheet**: Introduced a modal search view accessed from the Home screen toolbar for quick, custom city monitoring.
- **Dynamic City Manager**: Added `CityManager` persistence to save custom searched cities in `UserDefaults` so they are selectable in Settings.

## [1.0.0] - Initial Release

### Added
- Complete MVVM project architecture.
- **Home Screen**: Displays prominent AQI value, health recommendations, and detailed pollutant breakdowns (PM2.5, PM10, NO2, CO).
- **Map Screen**: MapKit integration with color-coded AQI markers for predefined cities in Sri Lanka.
- **Settings Screen**: Configuration for theme, location preferences, and local notifications.
- **Services**: Mock `APIService`, `LocationManager` for CoreLocation integration, and `NotificationService` for local alerts.
- **Utilities**: Centralized `Theme` definitions, `Constants`, and an `AQIHelper` for categorizing air quality levels.
