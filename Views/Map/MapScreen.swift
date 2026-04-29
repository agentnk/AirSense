import SwiftUI
import MapKit

struct MapScreen: View {
    @StateObject private var viewModel = MapViewModel()
    // Centered around Sri Lanka
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0)
    )
    @State private var showDetail = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region, annotationItems: viewModel.cities) { city in
                    MapAnnotation(coordinate: city.coordinate) {
                        MapAnnotationView(
                            city: city,
                            aqi: viewModel.aqiForCity(city.name),
                            color: viewModel.colorForCity(city.name)
                        )
                        .onTapGesture {
                            viewModel.selectedCity = city
                            showDetail = true
                        }
                    }
                }
                .ignoresSafeArea(edges: .top)
                
                if showDetail, let city = viewModel.selectedCity, let data = viewModel.cityAQIData[city.name] {
                    AQICardView(data: data)
                        .padding()
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: showDetail)
                }
            }
            .navigationTitle("AQI Map")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchAllCityData()
            }
            .onTapGesture {
                // Dismiss card when tapping outside
                showDetail = false
            }
        }
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
}
