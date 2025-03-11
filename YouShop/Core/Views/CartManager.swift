//
//  CartManager.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import Foundation

class CartManager: ObservableObject {
    @Published var items: [Product: Int] = [:]
    @Published var total: Double = 0.0
    
    static let shared = CartManager()
    
    private init() {}
    
    func addToCart(_ product: Product) {
        items[product, default: 0] += 1
        calculateTotal()
    }
    
    func removeFromCart(_ product: Product) {
        if let quantity = items[product], quantity > 1 {
            items[product] = quantity - 1
        } else {
            items.removeValue(forKey: product)
        }
        calculateTotal()
    }
    
    func clearCart() {
        items.removeAll()
        calculateTotal()
    }
    
    private func calculateTotal() {
        total = items.reduce(0) { $0 + ($1.key.price * Double($1.value)) }
    }
    
    var itemCount: Int {
        items.values.reduce(0, +)
    }
}

