# AirSense Lanka

AirSense Lanka is a production-ready iOS application built using SwiftUI that provides real-time Air Quality Index (AQI) monitoring for various locations across Sri Lanka. It utilizes modern Apple design guidelines, MVVM architecture, and smooth animations to deliver a premium user experience.

## Features

- **Real-Time AQI Monitoring**: View the current AQI based on your location or selected city.
- **Pollutant Breakdown**: Detailed metrics for PM2.5, PM10, NO2, and CO.
- **Interactive Map**: A MapKit-integrated screen showcasing AQI levels across Sri Lanka using color-coded markers.
- **Customizable Settings**: Choose default cities, toggle location usage, switch themes, and configure AQI alerts.
- **Local Notifications**: Receive automatic alerts when air quality reaches unhealthy levels.
- **Modern UI**: Apple-style minimalistic design using SF Symbols, rounded cards, and smooth transitions.

## Architecture

The project strictly follows the **MVVM (Model-View-ViewModel)** architectural pattern.

- **Models**: `AQIData` and `CityLocation` for representing data structures.
- **ViewModels**: `HomeViewModel`, `MapViewModel`, and `SettingsViewModel` handle business logic and state management.
- **Views**: SwiftUI-based, modular, and reusable components.
- **Services**: Dedicated managers for networking (`APIService`), location (`LocationManager`), and notifications (`NotificationService`).
- **Utilities**: Helpers for theming, static constants, and AQI calculations.

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone or download the repository.
2. Create a new iOS App project in Xcode named `AirSenseLK`.
3. Drag and drop the downloaded project folders (`App`, `Models`, `ViewModels`, `Views`, `Services`, `Utilities`) into the Xcode navigator.
4. Select your target device or simulator and run the application (`Cmd + R`).

## Author
Developed for Sri Lanka's air quality awareness.
