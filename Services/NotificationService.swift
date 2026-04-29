import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleAQIAlert(for aqi: Int, category: AQICategory) {
        guard aqi > 100 else { return } // Only alert for unhealthy levels
        
        let content = UNMutableNotificationContent()
        content.title = "Air Quality Alert"
        content.body = "Current AQI is \(aqi) (\(category.rawValue)). \(category.healthRecommendation)"
        content.sound = .default
        
        // Trigger immediately for demonstration, in production this might be based on background fetch
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
