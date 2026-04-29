# Changelog

All notable changes to the AirSense Lanka project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - Initial Release

### Added
- Complete MVVM project architecture.
- **Home Screen**: Displays prominent AQI value, health recommendations, and detailed pollutant breakdowns (PM2.5, PM10, NO2, CO).
- **Map Screen**: MapKit integration with color-coded AQI markers for predefined cities in Sri Lanka.
- **Settings Screen**: Configuration for theme, location preferences, and local notifications.
- **Services**: Mock `APIService`, `LocationManager` for CoreLocation integration, and `NotificationService` for local alerts.
- **Utilities**: Centralized `Theme` definitions, `Constants`, and an `AQIHelper` for categorizing air quality levels.
