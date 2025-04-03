//
//  YouShopApp.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 10/03/2025.
//

import SwiftUI
import Firebase
import UserNotifications

@main
struct YouShopApp: App {
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var cartManager = CartManager.shared
    @StateObject private var orderManager = OrderManager.shared
    @StateObject private var profileImageVM = ProfileImageViewModel.shared
    
    init() {
        FirebaseApp.configure()
        FontManager.registerFonts()
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        setupNotifications()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .environmentObject(cartManager)
                .environmentObject(orderManager)
                .environmentObject(profileImageVM)
        }
    }
    
    private func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification authorization granted")
            } else if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Add notification to NotificationManager when received
        let content = notification.request.content
        NotificationManager.shared.addNotification(content.body)
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle notification tap if needed
        completionHandler()
    }
}
