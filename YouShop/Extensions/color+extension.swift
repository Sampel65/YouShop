//
//  color+extension.swift
//  LivUp
//
//  Created by Tes on 21/01/2025.
//

import SwiftUI

extension Color {
    init(_ hex: String) {
        let sanitizedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: sanitizedHex)
        
        // Remove the "#" prefix if it exists
        if sanitizedHex.hasPrefix("#") {
            scanner.currentIndex = sanitizedHex.index(after: sanitizedHex.startIndex)
        }
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}
