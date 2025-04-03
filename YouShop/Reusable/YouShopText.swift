//
//  YouShopText.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI

struct YouShopText: View {
    let text: String
    var size: CGFloat = 16
    var color: Color = .primary
    var weight: FontManager.AfacadWeight = .regular
    
    init(_ text: String, size: CGFloat = 16, color: Color = .primary, weight: FontManager.AfacadWeight = .regular) {
        self.text = text
        self.size = size
        self.color = color
        self.weight = weight
    }
    
    var body: some View {
        Text(text)
            .font(FontManager.afacad(size, weight: weight))
            .foregroundColor(color)
    }
}

struct YouShopText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            YouShopText("Regular Text")
            YouShopText("Large Text", size: 24)
            YouShopText("Colored Text", color: .blue)
            YouShopText("Bold Text", weight: .semiBold)
        }
        .padding()
    }
}
