//
//  CheckoutView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager
    @State private var showAddAddress = false
    @State private var showPaymentMethod = false
    @State private var address = ""
    @State private var paymentMethod = "Cash on Delivery"
    @State private var showOrderSuccess = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(12)
                        .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                YouShopText("Checkout", size: 20, weight: .semiBold)
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 16) {
                    // Shipping Address Section
                    VStack(alignment: .leading, spacing: 8) {
                        YouShopText("Shipping Address", size: 14, weight: .regular)
                            .foregroundColor(.gray)
                        
                        Button(action: { showAddAddress.toggle() }) {
                            HStack {
                                Text(address.isEmpty ? "Add Shipping Address" : address)
                                    .afacadFont(16)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Payment Method Section
                    VStack(alignment: .leading, spacing: 8) {
                        YouShopText("Payment Method", size: 14, weight: .regular)
                            .foregroundColor(.gray)
                        
                        Button(action: { showPaymentMethod.toggle() }) {
                            HStack {
                                Text(paymentMethod)
                                    .afacadFont(16)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Add Address Sheet
                    if showAddAddress {
                        VStack(alignment: .leading, spacing: 16) {
                            YouShopTextTextfield(
                                title: "Address",
                                text: $address,
                                placeholder: "Enter your address",
                                isSecure: false
                            )
                            
                            YouShopButton(
                                title: "Save Address",
                                height: 56,
                                cornerRadius: 28,
                                action: {
                                    showAddAddress = false
                                }
                            )
                        }
                        .padding()
                        .background(Color(colorScheme == .dark ? AppColor.blackBackgroundColor : AppColor.whiteBackgroundColor))
                        .cornerRadius(12)
                    }
                }
                .padding()
                
                Spacer()
            }
            
            // Order Summary
            VStack(spacing: 12) {
                PriceLine(title: "Subtotal", amount: cartManager.total)
                PriceLine(title: "Shipping Cost", amount: 8.00)
                PriceLine(title: "Tax", amount: 0.00)
                Divider()
                PriceLine(title: "Total", amount: cartManager.total + 8.00)
                    .fontWeight(.bold)
            }
            .padding()
            
            // Place Order Button
            YouShopButton(
                title: "Place Order $\(String(format: "%.2f", cartManager.total + 8.00))",
                height: 56,
                cornerRadius: 28,
                action: {
                    placeOrder()
                }
            )
            .padding(.horizontal)
            .disabled(address.isEmpty)
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showOrderSuccess) {
            OrderSuccessView()
                .navigationBarBackButtonHidden(true)
        }
    }
    
    private func placeOrder() {
        // Add order to OrderManager (notification will be handled inside OrderManager)
        orderManager.addOrder(
            items: cartManager.items,
            total: cartManager.total + 8.00,
            address: address,
            paymentMethod: paymentMethod
        )
        
        // Clear cart and navigate to success
        cartManager.clearCart()
        showOrderSuccess = true
    }
}
