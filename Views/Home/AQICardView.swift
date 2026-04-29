import SwiftUI

struct AQICardView: View {
    let data: AppAQIData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(data.locationName)
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                    
                    Text("Air Quality Index")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                VStack {
                    Text("\(data.aqiValue)")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(data.category.color)
                    
                    Text(data.category.rawValue)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(data.category.color.opacity(0.2))
                        .foregroundColor(data.category.color)
                        .clipShape(Capsule())
                }
            }
            
            Divider()
            
            Text(data.category.healthRecommendation)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Spacer()
                Text("Last updated: \(formattedDate(data.lastUpdated))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(24)
        .background(Theme.secondaryBackground)
        .cornerRadius(Theme.cardCornerRadius)
        .shadow(color: Color.black.opacity(Theme.shadowOpacity), radius: Theme.shadowRadius, x: 0, y: 4)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AQICardView_Previews: PreviewProvider {
    static var previews: some View {
        AQICardView(data: AppAQIData(
            aqiValue: 65,
            category: .moderate,
            locationName: "Colombo",
            pollutants: [],
            lastUpdated: Date()
        ))
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
