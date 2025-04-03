//
//  YouShopButton.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI

struct YouShopButton: View {
    let title: String
    let loadingTitle: String?
    let isLoading: Bool
    var height: CGFloat
    var cornerRadius: CGFloat
    var textSize: CGFloat
    var lightModeBackgroundColor: Color
    var darkModeBackgroundColor: Color
    var lightModeForegroundColor: Color
    var darkModeForegroundColor: Color
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    

    var leadingIcon: (() -> Image)?

    init(
        title: String,
        loadingTitle: String? = nil,
        isLoading: Bool = false,
        height: CGFloat = 46,
        cornerRadius: CGFloat = 12,
        textSize: CGFloat = 16,
        lightModeBackgroundColor: Color = Color(AppColor.blackBackgroundColor),
        darkModeBackgroundColor: Color = Color(AppColor.whiteBackgroundColor),
        lightModeForegroundColor: Color = Color(AppColor.whiteBackgroundColor),
        darkModeForegroundColor: Color = Color(AppColor.blackBackgroundColor),
        leadingIcon: (() -> Image)? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.loadingTitle = loadingTitle
        self.isLoading = isLoading
        self.height = height
        self.cornerRadius = cornerRadius
        self.textSize = textSize
        self.lightModeBackgroundColor = lightModeBackgroundColor
        self.darkModeBackgroundColor = darkModeBackgroundColor
        self.lightModeForegroundColor = lightModeForegroundColor
        self.darkModeForegroundColor = darkModeForegroundColor
        self.leadingIcon = leadingIcon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let icon = leadingIcon {
                    icon()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(
                            tint: colorScheme == .dark ? .black : .white
                        ))
                        .frame(width: 20, height: 20)
                }
                
                Text(isLoading ? (loadingTitle ?? "Loading...") : title)
                    .afacadFont(textSize, weight: .semiBold)
                    .foregroundColor(colorScheme == .dark ? darkModeForegroundColor : lightModeForegroundColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(colorScheme == .dark ? darkModeBackgroundColor : lightModeBackgroundColor)
            .cornerRadius(cornerRadius)
        }
        .disabled(isLoading)
    }
}

#Preview {
    YouShopButton(title: "Hello, World!", action: {})
}
