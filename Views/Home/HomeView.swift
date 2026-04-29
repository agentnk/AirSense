import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(locationManager: LocationManager) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(locationManager: locationManager))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBackground.ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.aqiData == nil {
                    LoadingView(message: "Updating Data...")
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else if let data = viewModel.aqiData {
                    contentView(data)
                } else {
                    LoadingView(message: "Initializing...")
                }
            }
            .navigationTitle("AirSense Lanka")
            .task {
                await viewModel.refreshData()
            }
        }
    }
    
    @ViewBuilder
    private func contentView(_ data: AppAQIData) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                AQICardView(data: data)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Pollutant Breakdown")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(data.pollutants) { pollutant in
                            pollutantCard(pollutant)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .refreshable {
            await viewModel.refreshData()
        }
    }
    
    @ViewBuilder
    private func pollutantCard(_ pollutant: Pollutant) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(pollutant.name)
                .font(.headline)
                .foregroundColor(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(String(format: "%.1f", pollutant.value))
                    .font(.system(.title2, design: .rounded).weight(.bold))
                Text(pollutant.unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            Text("Failed to load data")
                .font(.headline)
            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Try Again") {
                Task {
                    await viewModel.refreshData()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(locationManager: LocationManager())
    }
}
