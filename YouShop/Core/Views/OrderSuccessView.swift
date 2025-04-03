//
//  OrderSuccessView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI

struct OrderSuccessView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToMain = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image("order_success")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            
                VStack(spacing: 8) {
                    YouShopText("Order Placed Successfully", size: 24, weight: .semiBold)
                    YouShopText("You will recieve an email confirmation", size: 14)
                        .foregroundColor(.gray)
                }
            
                YouShopButton(
                    title: "See Order details",
                    height: 56,
                    cornerRadius: 28,
                    action: {
                        navigateToMain = true
                    }
                )
                .frame(maxWidth: 200)
            }
            .padding()
            .navigationDestination(isPresented: $navigateToMain) {
                MainTabView(selectedTab: 2)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}
