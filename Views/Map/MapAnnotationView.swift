import SwiftUI

struct MapAnnotationView: View {
    let city: CityLocation
    let aqi: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Text(aqi)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color)
                .clipShape(Capsule())
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -2)
        }
    }
}

struct MapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        MapAnnotationView(
            city: CityLocation.predefinedCities[0],
            aqi: "65",
            color: .yellow
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
