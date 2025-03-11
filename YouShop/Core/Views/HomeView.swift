//
//  HomeView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 10/03/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var searchText = ""
    @EnvironmentObject private var cartManager: CartManager
    @State private var showCart = false
    
    var body: some View {
        
        VStack(spacing: 16) {
            // Header
            header
            searchBar
            
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            } else if !viewModel.filteredProducts.isEmpty {
                // ScrollView starts from categories
                ScrollView {
                    VStack(spacing: 24) {
                        // Categories
                        categoriesSection
                        
                        // Products grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(viewModel.filteredProducts) { product in
                                NavigationLink {
                                    ProductDetailView(product: product)
                                        .navigationBarBackButtonHidden(true)
                                } label: {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(.horizontal, 16)
                }
                .refreshable {
                    // Clear cache and fetch fresh data
                    viewModel.clearCache()
                    viewModel.fetchProducts()
                }
            } else {
                // Empty or error state
                VStack(spacing: 16) {
                    Spacer()
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Try Again") {
                            viewModel.clearCache()
                            viewModel.fetchProducts()
                        }
                        .foregroundColor(Color(AppColor.primaryColor))
                    } else {
                        Text("No products found")
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color(colorScheme == .dark ? AppColor.blackBackgroundColor : AppColor.whiteBackgroundColor))
        .onAppear {
            viewModel.fetchProducts()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var header: some View {
        HStack {
            Image("img")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Spacer()
            
            Menu {
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    Button(category.displayName) {
                        viewModel.selectedCategory = category
                    }
                }
                Button("All") {
                    viewModel.selectedCategory = nil
                }
            } label: {
                HStack {
                    YouShopText(viewModel.selectedCategory?.displayName ?? "All", size: 16)
                    Image(systemName: "chevron.down")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                .cornerRadius(20)
            }
            
            Spacer()
            
            NavigationLink(destination: CartView()) {
                ZStack(alignment: .topTrailing) {
                    Image("cart")
                        .foregroundColor(Color(AppColor.primaryColor))
                        .frame(width: 40, height: 40)
                        .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                        .clipShape(Circle())
                    
                    if cartManager.itemCount > 0 {
                        Text("\(cartManager.itemCount)")
                            .font(.caption2)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Color(AppColor.primaryColor))
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                    }
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
                .afacadFont(14, weight: .regular)
        }
        .padding(12)
        .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
        .cornerRadius(12)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                YouShopText("Categories", size: 20, weight: .semiBold)
                Spacer()
                Button(action: {}) {
                    YouShopText("See All", size: 14)
                        .foregroundColor(Color(AppColor.primaryColor))
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(ProductCategory.allCases, id: \.self) { category in
                        categoryButton(category)
                    }
                }
            }
        }
    }
    
    private func categoryButton(_ category: ProductCategory) -> some View {
        Button(action: { viewModel.selectedCategory = category }) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                YouShopText(category.displayName, size: 12)
                    .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(viewModel.selectedCategory == category ? Color(AppColor.primaryColor) : Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
            .cornerRadius(12)
        }
    }
}

struct ProductCard: View {
    let product: Product
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
           
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                case .failure(_):
                    Image(systemName: "photo")
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 150)
            .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
            
            // Rest of the card content remains the same
            VStack(alignment: .leading, spacing: 4) {
                YouShopText(product.title, size: 14, weight: .medium)
                    .lineLimit(2)
                
                HStack {
                    YouShopText("$\(String(format: "%.2f", product.price))", size: 16, weight: .semiBold)
                        .foregroundColor(Color(AppColor.primaryColor))
                    
                    Spacer()
                    
                    Button(action: {
                        cartManager.addToCart(product)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(AppColor.primaryColor))
                            .font(.system(size: 24))
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
        .cornerRadius(12)
    }
}
