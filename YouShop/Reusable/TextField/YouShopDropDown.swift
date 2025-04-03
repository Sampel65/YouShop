//
//  YouShopDropDown.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI



struct YouShopDropDown<T: Hashable>: View {
    let title: String
    let placeholder: String
    let options: [T]
    @Binding var selection: T?
    let optionToString: (T) -> String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    VStack(alignment: .leading) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                self.selection = option
                                withAnimation {
                                    self.isExpanded.toggle()
                                }
                            }) {
                                Text(optionToString(option))
                                    .foregroundColor(.primary)
                                    .padding(.vertical, 8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 8)
                },
                label: {
                    HStack {
                        Text(selection.map(optionToString) ?? placeholder)
                            .foregroundColor(selection == nil ? .gray : .primary)
                        Spacer()
                    }
                }
            )
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

