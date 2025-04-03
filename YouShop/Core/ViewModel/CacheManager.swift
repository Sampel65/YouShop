
//
//  CacheManager.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let productsKey = "cached_products"
    
    private init() {}
    
    func saveProducts(_ products: [Product]) {
        do {
            let data = try JSONEncoder().encode(products)
            UserDefaults.standard.set(data, forKey: productsKey)
        } catch {
            print("Error caching products: \(error)")
        }
    }
    
    func loadProducts() -> [Product]? {
        guard let data = UserDefaults.standard.data(forKey: productsKey) else { return nil }
        do {
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            print("Error loading cached products: \(error)")
            return nil
        }
    }
    
    func clearCache() {
        
        UserDefaults.standard.removeObject(forKey: productsKey)
    }
}

