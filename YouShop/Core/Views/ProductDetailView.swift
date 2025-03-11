//
//  ProductDetailView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//


import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartManager: CartManager
    @State private var selectedSize = "S"
    @State private var selectedColor = "Default"
    @State private var quantity = 1
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Back and favorite buttons
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(12)
                            .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "heart")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(12)
                            .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                
                // Product Image
                TabView {
                    AsyncImage(url: URL(string: product.image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 300)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                        case .failure(_):
                            Image(systemName: "photo")
                                .frame(height: 300)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 300)
                }
                .tabViewStyle(.page)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                
                VStack(alignment: .leading, spacing: 12) {
                    YouShopText(product.title, size: 24, weight: .semiBold)
                    
                    YouShopText("$\(String(format: "%.2f", product.price))", size: 20, weight: .semiBold)
                        .foregroundColor(Color(AppColor.primaryColor))
                    
                    YouShopText("Rating: \(String(format: "%.1f", product.rating.rate)) (\(product.rating.count) reviews)", size: 14)
                        .foregroundColor(.gray)
                    
                    // Size Selection
                    VStack(alignment: .leading, spacing: 8) {
                        YouShopText("Size", size: 16, weight: .medium)
                        Menu {
                            ForEach(["S", "M", "L", "XL"], id: \.self) { size in
                                Button(size) { selectedSize = size }
                            }
                        } label: {
                            HStack {
                                Text(selectedSize)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Color Selection
                    VStack(alignment: .leading, spacing: 8) {
                        YouShopText("Color", size: 16, weight: .medium)
                        Menu {
                            ForEach(["Default", "Black", "White"], id: \.self) { color in
                                Button(color) { selectedColor = color }
                            }
                        } label: {
                            HStack {
                                Text(selectedColor)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Quantity
                    VStack(alignment: .leading, spacing: 8) {
                        YouShopText("Quantity", size: 16, weight: .medium)
                        HStack {
                            Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                Image(systemName: "minus")
                                    .padding(12)
                                    .background(Color(AppColor.primaryColor))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            
                            Text("\(quantity)")
                                .frame(width: 40)
                            
                            Button(action: { quantity += 1 }) {
                                Image(systemName: "plus")
                                    .padding(12)
                                    .background(Color(AppColor.primaryColor))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    YouShopText(product.description, size: 16)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Add to Cart Button
                YouShopButton(
                    title: "Add to Cart",
                    height: 56,
                    cornerRadius: 28,
                    action: {
                        for _ in 0..<quantity {
                            cartManager.addToCart(product)
                        }
                    }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .navigationBarHidden(true)
    }
}
