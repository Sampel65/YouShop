//
//  OrdersView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI
import Foundation

struct OrdersView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedStatus: OrderStatus = .processing
    @StateObject private var orderManager = OrderManager.shared
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            YouShopText("Orders", size: 24, weight: .semiBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // Status filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(OrderStatus.allCases, id: \.self) { status in
                        statusButton(status)
                    }
                }
                .padding(.horizontal)
            }
            
            if orderManager.orders.isEmpty {
                // Empty state
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "doc.text")
                        .font(.system(size: 60))
                        .foregroundColor(Color(AppColor.primaryColor))
                    
                    YouShopText("No orders yet", size: 20, weight: .semiBold)
                    
                    YouShopButton(
                        title: "Start Shopping",
                        height: 56,
                        cornerRadius: 28,
                        action: {
                            // Switch to home tab (index 0)
                            NotificationCenter.default.post(
                                name: Notification.Name("SwitchToTab"),
                                object: nil,
                                userInfo: ["tabIndex": 0]
                            )
                        }
                    )
                    .frame(maxWidth: 200)
                    
                    Spacer()
                }
            } else {
                // Orders list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredOrders) { order in
                            OrderRow(order: order)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top, 16)
    }
    
    private var filteredOrders: [Order] {
        orderManager.orders.filter { $0.status == selectedStatus }
    }
    
    private func statusButton(_ status: OrderStatus) -> some View {
        Button(action: { selectedStatus = status }) {
            Text(status.rawValue)
                .afacadFont(14, weight: .medium)
                .foregroundColor(selectedStatus == status ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(selectedStatus == status ? Color(status.color) : Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                .cornerRadius(20)
        }
    }
}

struct OrderRow: View {
    let order: Order
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Image("saved")
            HStack {
                YouShopText("Order #\(order.id)", size: 16, weight: .medium)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
            YouShopText("\(order.itemCount) items", size: 14)
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
        .cornerRadius(12)
    }
}
