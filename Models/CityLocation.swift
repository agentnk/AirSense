import Foundation
import CoreLocation

struct CityLocation: Identifiable, Hashable, Codable {
    var id: String { name }
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static let predefinedCities = [
        CityLocation(name: "Colombo", latitude: 6.9271, longitude: 79.8612),
        CityLocation(name: "Kandy", latitude: 7.2906, longitude: 80.6337),
        CityLocation(name: "Galle", latitude: 6.0328, longitude: 80.2150),
        CityLocation(name: "Jaffna", latitude: 9.6615, longitude: 80.0255)
    ]
}
