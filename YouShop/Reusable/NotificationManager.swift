import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notifications: [NotificationItem] = []
    private let notificationsKey = "stored_notifications"
    
    init() {
        loadNotifications()
        requestAuthorization()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification authorization granted")
            } else if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func sendOrderNotification(orderId: String) {
        let content = UNMutableNotificationContent()
        content.title = "Order Confirmation"
        content.body = "Your order #\(orderId) has been placed successfully!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        // Add to local notifications list
        DispatchQueue.main.async {
            self.addNotification("Order #\(orderId) has been placed successfully!")
        }
    }
    
    func addNotification(_ message: String) {
        let notification = NotificationItem(message: message, timestamp: Date(), isRead: false)
        DispatchQueue.main.async {
            self.notifications.insert(notification, at: 0) // Add new notifications at the top
            self.saveNotifications()
        }
    }
    
    func saveNotifications() {
        if let encoded = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(encoded, forKey: notificationsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func loadNotifications() {
        if let data = UserDefaults.standard.data(forKey: notificationsKey),
           let decoded = try? JSONDecoder().decode([NotificationItem].self, from: data) {
            self.notifications = decoded.sorted(by: { $0.timestamp > $1.timestamp })
        }
    }
    
    func markAsRead(_ notification: NotificationItem) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
            saveNotifications()
        }
    }
    
    func clearAllNotifications() {
        notifications.removeAll()
        saveNotifications()
    }
}
