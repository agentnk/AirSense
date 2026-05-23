import Foundation

class CityManager {
    static let shared = CityManager()
    private let key = "SavedCities"
    
    private init() {}
    
    func getCities() -> [CityLocation] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([CityLocation].self, from: data) else {
            return CityLocation.predefinedCities
        }
        return decoded
    }
    
    func addCity(_ city: CityLocation) {
        var current = getCities()
        if !current.contains(where: { $0.name.lowercased() == city.name.lowercased() }) {
            current.append(city)
            save(current)
        }
    }
    
    private func save(_ cities: [CityLocation]) {
        if let encoded = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
