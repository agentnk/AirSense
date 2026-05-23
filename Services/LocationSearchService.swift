import Foundation
import MapKit

class LocationSearchService: ObservableObject {
    @Published var searchResults: [SearchResultItem] = []
    @Published var isSearching = false
    
    func search(query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            await MainActor.run {
                self.searchResults = []
                self.isSearching = false
            }
            return
        }
        
        await MainActor.run {
            self.isSearching = true
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        // Bias results towards Sri Lanka
        let sriLankaCenter = CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718)
        let sriLankaSpan = MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0)
        request.region = MKCoordinateRegion(center: sriLankaCenter, span: sriLankaSpan)
        
        let search = MKLocalSearch(request: request)
        do {
            let response = try await search.start()
            let items = response.mapItems.compactMap { item -> SearchResultItem? in
                guard let name = item.name else { return nil }
                let location = item.placemark.coordinate
                
                var subtitleParts: [String] = []
                if let locality = item.placemark.locality {
                    subtitleParts.append(locality)
                }
                if let adminArea = item.placemark.administrativeArea {
                    subtitleParts.append(adminArea)
                }
                if let country = item.placemark.country {
                    subtitleParts.append(country)
                }
                
                let subtitle = subtitleParts.joined(separator: ", ")
                
                return SearchResultItem(
                    name: name,
                    subtitle: subtitle,
                    latitude: location.latitude,
                    longitude: location.longitude
                )
            }
            
            await MainActor.run {
                self.searchResults = items
                self.isSearching = false
            }
        } catch {
            print("Location search error: \(error.localizedDescription)")
            await MainActor.run {
                self.searchResults = []
                self.isSearching = false
            }
        }
    }
}
