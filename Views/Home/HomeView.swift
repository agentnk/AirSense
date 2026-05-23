import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.primaryBackground.ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.aqiData == nil {
                    LoadingView(message: Constants.Strings.updatingData)
                } else if let error = viewModel.errorMessage {
                    ErrorStateView(error: error, retryAction: {
                        Task {
                            await viewModel.refreshData()
                        }
                    })
                } else if let data = viewModel.aqiData {
                    ScrollView {
                        VStack(spacing: 24) {
                            AQICardView(data: data)
                                .padding(.horizontal)
                            
                            PollutantGridView(pollutants: data.pollutants)
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await viewModel.refreshData()
                    }
                } else {
                    LoadingView(message: Constants.Strings.initializing)
                }
            }
            .navigationTitle(Constants.Strings.appName)
            .task {
                await viewModel.refreshData()
            }
        }
    }
}

// MARK: - Subcomponents

struct PollutantGridView: View {
    let pollutants: [Pollutant]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Constants.Strings.pollutantBreakdown)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(pollutants) { pollutant in
                    PollutantCardView(pollutant: pollutant)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct PollutantCardView: View {
    let pollutant: Pollutant
    
    var body: some View {
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
}

struct ErrorStateView: View {
    let error: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            Text(Constants.Strings.failedToLoad)
                .font(.headline)
            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(Constants.Strings.tryAgain) {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let api = APIService()
        let loc = LocationManager()
        let notif = NotificationService()
        HomeView()
            .environmentObject(HomeViewModel(apiService: api, locationManager: loc, notificationService: notif))
    }
}
