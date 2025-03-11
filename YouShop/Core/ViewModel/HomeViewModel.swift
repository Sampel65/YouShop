
//
//  HomeViewModel.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//


import Foundation
import Alamofire

class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: ProductCategory? = nil
    @Published var filteredProducts: [Product] = []
    private let userDefaults = UserDefaults.standard
    private let productsKey = "cachedProducts"
    
    func fetchProducts() {
        isLoading = true
        if let cachedData = userDefaults.data(forKey: productsKey),
           let products = try? JSONDecoder().decode([Product].self, from: cachedData) {
            self.products = products
            self.filteredProducts = filterProducts(products)
            self.isLoading = false
            return
        }
        
        AF.request("https://fakestoreapi.com/products")
            .validate()
            .responseDecodable(of: [Product].self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let products):
                    if let encodedData = try? JSONEncoder().encode(products) {
                        self.userDefaults.set(encodedData, forKey: self.productsKey)
                    }
                    
                    DispatchQueue.main.async {
                        self.products = products
                        self.filteredProducts = self.filterProducts(products)
                        self.isLoading = false
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                }
            }
    }
    
    private func filterProducts(_ products: [Product]) -> [Product] {
        guard let category = selectedCategory else {
            return products
        }
        return products.filter { $0.category == category.rawValue }
    }
    
    func clearCache() {
        userDefaults.removeObject(forKey: productsKey)
    }
}
