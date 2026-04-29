import SwiftUI

struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.primaryBackground.ignoresSafeArea())
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(message: "Fetching Air Quality...")
    }
}
