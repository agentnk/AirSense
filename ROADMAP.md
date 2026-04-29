# Roadmap

This document outlines the planned features and technical debt to be addressed in upcoming releases of AirSense Lanka.

## Short-Term Goals

- **Live API Integration**: Replace the current mock `APIService` with a live integration using OpenAQ or AQICN for real-world Sri Lankan data.
- **Data Caching & Offline Support**: Implement a robust caching mechanism (e.g., using `UserDefaults` or local file storage) so the app can display the last known AQI when offline.
- **Location Search**: Add a search bar to the Home or Map screen allowing users to find AQI for specific towns/cities beyond the predefined list.

## Medium-Term Goals

- **Widgets**: Create iOS Home Screen and Lock Screen widgets for quick AQI glances.
- **SwiftData Migration**: Migrate from simple UserDefaults/AppStorage to SwiftData for historical AQI tracking and charting.
- **Historical Charts**: Introduce a new view showing AQI trends over the past week/month using Swift Charts.

## Long-Term Goals

- **Push Notifications**: Integrate a backend service to send critical push notifications during severe pollution events across the island.
- **watchOS Companion App**: Build an Apple Watch application to display complications with the current AQI.
- **Crowdsourced Data**: Allow users to report localized air quality indicators or sync with personal air quality monitors.
