//
//  Product.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//


import Foundation

struct Product: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}


struct Rating: Codable, Hashable {
    let rate: Double
    let count: Int
}

enum ProductCategory: String, CaseIterable {
    case electronics = "electronics"
    case jewelry = "jewelery"
    case menClothing = "men's clothing"
    case womenClothing = "women's clothing"
    
    var displayName: String {
        switch self {
        case .electronics: return "Electronics"
        case .jewelry: return "Jewelry"
        case .menClothing: return "Men"
        case .womenClothing: return "Women"
        }
    }
    
    var icon: String {
        switch self {
        case .electronics: return "laptopcomputer"
        case .jewelry: return "gift"
        case .menClothing: return "tshirt"
        case .womenClothing: return "bag"
        }
    }
}
