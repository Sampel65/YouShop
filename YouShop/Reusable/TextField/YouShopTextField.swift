//
//  YouShopTextField.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI



struct YouShopTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}
