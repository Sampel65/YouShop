import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification authorization granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendOrderNotification(orderId: String) {
        let content = UNMutableNotificationContent()
        content.title = "Order Placed"
        content.body = "Your Order #\(orderId) has been confirmed"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        // Add to notifications view
        NotificationCenter.default.post(
            name: NSNotification.Name("NewOrderNotification"),
            object: nil,
            userInfo: ["message": "Order #\(orderId) has been confirmed check your order history for full details"]
        )
    }
}

// End of file
