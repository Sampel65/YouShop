//
//  NotificationsView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI

// Placeholder views
struct NotificationsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var notificationManager: NotificationManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                YouShopText("Notifications", size: 24, weight: .semiBold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if !notificationManager.notifications.isEmpty {
                    Button("Clear All") {
                        notificationManager.clearAllNotifications()
                    }
                    .foregroundColor(Color(AppColor.primaryColor))
                }
            }
            .padding(.horizontal)
            
            if notificationManager.notifications.isEmpty {
                // Empty state
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "bell")
                        .font(.system(size: 60))
                        .foregroundColor(Color(AppColor.primaryColor))
                    
                    YouShopText("No Notification yet", size: 20, weight: .semiBold)
                    
                    YouShopButton(
                        title: "Explore Categories",
                        height: 56,
                        cornerRadius: 28,
                        action: {}
                    )
                    .frame(maxWidth: 200)
                    
                    Spacer()
                }
            } else {
                // Notification list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(notificationManager.notifications) { notification in
                            NotificationRow(notification: notification)
                                .onTapGesture {
                                    notificationManager.markAsRead(notification)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top, 16)
    }
}

struct NotificationRow: View {
    let notification: NotificationItem
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            // Left side - Icon and blue dot for unread
            ZStack {
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(AppColor.primaryColor))
                
                if !notification.isRead {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                        .offset(x: 8, y: -8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                YouShopText(notification.message, size: 14)
                    .lineLimit(2)
                
                Text(notification.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
        .cornerRadius(12)
        .opacity(notification.isRead ? 0.8 : 1)
    }
}

