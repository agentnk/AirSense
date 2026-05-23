import SwiftUI
import MapKit

struct MapScreen: View {
    @EnvironmentObject private var viewModel: MapViewModel
    @State private var showDetail = false
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Map View
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.cities) { city in
                    MapAnnotation(coordinate: city.coordinate) {
                        MapAnnotationView(
                            city: city,
                            aqi: viewModel.aqiForCity(city.name),
                            color: viewModel.colorForCity(city.name)
                        )
                        .onTapGesture {
                            viewModel.selectedCity = city
                            showDetail = true
                            isSearchFocused = false
                        }
                    }
                }
                .ignoresSafeArea(edges: .all)
                .onTapGesture {
                    showDetail = false
                    isSearchFocused = false
                }
                
                // Overlays
                VStack(spacing: 0) {
                    // Floating Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search locations in Sri Lanka...", text: $viewModel.searchQuery)
                            .focused($isSearchFocused)
                            .submitLabel(.search)
                            .autocorrectionDisabled()
                        
                        if viewModel.isSearching {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else if !viewModel.searchQuery.isEmpty {
                            Button(action: {
                                viewModel.searchQuery = ""
                                viewModel.searchResults = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Theme.secondaryBackground.opacity(0.95))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    // Search results dropdown list
                    if isSearchFocused && !viewModel.searchResults.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(viewModel.searchResults) { item in
                                    Button(action: {
                                        viewModel.selectSearchResult(item)
                                        showDetail = true
                                        isSearchFocused = false
                                    }) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            if !item.subtitle.isEmpty {
                                                Text(item.subtitle)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 16)
                                        .contentShape(Rectangle())
                                    }
                                    
                                    if item != viewModel.searchResults.last {
                                        Divider()
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                        }
                        .background(Theme.secondaryBackground.opacity(0.95))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                        .frame(maxHeight: 250)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    
                    Spacer()
                    
                    // City Detail card
                    if showDetail, let city = viewModel.selectedCity, let data = viewModel.cityAQIData[city.name] {
                        AQICardView(data: data)
                            .padding()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.spring(), value: showDetail)
                    }
                }
            }
            .navigationTitle("AQI Map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .task {
                await viewModel.fetchAllCityData()
            }
        }
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
            .environmentObject(MapViewModel(apiService: APIService()))
    }
}

