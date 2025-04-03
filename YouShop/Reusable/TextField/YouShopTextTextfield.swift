//
//  YouShopTextTextfield.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI

struct YouShopTextTextfield: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @FocusState private var isFocusedInternal: Bool
    
    init(
        title: String,
        text: Binding<String>,
        placeholder: String,
        isSecure: Bool = false
    ) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .focused($isFocusedInternal)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .focused($isFocusedInternal)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}
