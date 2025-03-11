//
//  CartView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var cartManager: CartManager
    @State private var couponCode = ""
    @State private var showCheckout = false
    
    var body: some View {
        VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        NotificationCenter.default.post(name: Notification.Name("SwitchToTab"), object: nil, userInfo: ["tabIndex": 0])
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(12)
                            .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                            .clipShape(Circle())
                    }

                    
                    Spacer()
                    
                    YouShopText("Cart", size: 20, weight: .semiBold)
                    
                    Spacer()
                    
                    if !cartManager.items.isEmpty {
                        Button("Remove All") {
                            cartManager.clearCart()
                        }
                        .foregroundColor(Color(AppColor.primaryColor))
                    }
                }
                .padding(.horizontal)
                
                if cartManager.items.isEmpty {
                    // Empty cart view
                    VStack(spacing: 20) {
                        Image("bag")
                            .font(.system(size: 60))
                            .foregroundColor(Color(AppColor.primaryColor))
                        
                        YouShopText("Your Cart is Empty", size: 20, weight: .semiBold)
                        
                        Button(action: { dismiss() }) {
                            YouShopText("Explore Categories", size: 16, weight: .medium)
                                .frame(maxWidth: 200)
                                .frame(height: 56)
                                .background(Color(AppColor.primaryColor))
                                .foregroundColor(.white)
                                .cornerRadius(28)
                        }
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    // Cart Items in ScrollView
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(cartManager.items.keys), id: \.id) { product in
                                CartItemRow(product: product, quantity: cartManager.items[product] ?? 0)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Order Summary
                    VStack(spacing: 16) {
                        // Price Lines
                        VStack(spacing: 12) {
                            PriceLine(title: "Subtotal", amount: cartManager.total)
                            PriceLine(title: "Shipping Cost", amount: 8.00)
                            PriceLine(title: "Tax", amount: 0.00)
                            Divider()
                            PriceLine(title: "Total", amount: cartManager.total + 8.00)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                        
                        // Coupon Code
                        HStack(spacing: 12) {
                            Image(systemName: "ticket")
                                .foregroundColor(.gray)
                            
                            TextField("Enter Coupon Code", text: $couponCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {}) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color(AppColor.primaryColor))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(12)
                        .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        YouShopButton(
                            title: "Checkout",
                            height: 56,
                            cornerRadius: 28,
                            action: {
                                showCheckout = true
                            }
                        )
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                    .background(Color(colorScheme == .dark ? AppColor.blackBackgroundColor : AppColor.whiteBackgroundColor))
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $showCheckout) {
                CheckoutView()
            }
    }
}

struct CartItemRow: View {
    let product: Product
    let quantity: Int
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Product Image
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(_):
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            // Product Details
            VStack(alignment: .leading, spacing: 4) {
                YouShopText(product.title, size: 14, weight: .medium)
                    .lineLimit(1)
                
                HStack {
                    YouShopText("Size: M · Color: Default", size: 12)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Price and Controls
            VStack(alignment: .trailing, spacing: 8) {
                YouShopText("$\(String(format: "%.2f", product.price))", size: 16, weight: .semiBold)
                    .foregroundColor(Color(AppColor.primaryColor))
                
                // Quantity Controls
                HStack(spacing: 12) {
                    Button(action: { cartManager.removeFromCart(product) }) {
                        Image(systemName: "minus")
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color(AppColor.primaryColor))
                            .clipShape(Circle())
                    }
                    
                    Text("\(quantity)")
                        .frame(width: 24)
                        .font(.system(size: 16))
                    
                    Button(action: { cartManager.addToCart(product) }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color(AppColor.primaryColor))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
        .cornerRadius(12)
    }
}

struct PriceLine: View {
    let title: String
    let amount: Double
    
    var body: some View {
        HStack {
            YouShopText(title, size: 14, weight: .regular)
                .foregroundColor(.gray)
            Spacer()
            YouShopText("$\(String(format: "%.2f", amount))", size: 14, weight: .medium)
        }
    }
}
