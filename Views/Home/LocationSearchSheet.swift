import SwiftUI
import Combine

struct LocationSearchSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var searchService = LocationSearchService()
    @State private var searchQuery = ""
    
    // Callback when a city is selected
    var onSelect: (CityLocation) -> Void
    
    // Task reference for debouncing search query
    @State private var searchTask: Task<Void, Never>? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search towns or cities...", text: $searchQuery)
                        .submitLabel(.search)
                        .autocorrectionDisabled()
                        .onChange(of: searchQuery) { newValue in
                            // Debounce search query changes
                            searchTask?.cancel()
                            searchTask = Task {
                                do {
                                    try await Task.sleep(nanoseconds: 500_000_000) // 0.5s debounce
                                    guard !Task.isCancelled else { return }
                                    await searchService.search(query: newValue)
                                } catch {
                                    // Handle cancellation or error
                                }
                            }
                        }
                    
                    if searchService.isSearching {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else if !searchQuery.isEmpty {
                        Button(action: {
                            searchQuery = ""
                            searchService.searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top)
                
                if searchQuery.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("Search for any city in Sri Lanka")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Find real-time air quality index metrics.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else if searchService.searchResults.isEmpty && !searchService.isSearching {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No results found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Try searching for Sri Lankan towns like Colombo, Negombo, Kandy, etc.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                    }
                } else {
                    List(searchService.searchResults) { item in
                        Button(action: {
                            let city = CityLocation(name: item.name, latitude: item.latitude, longitude: item.longitude)
                            onSelect(city)
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
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
