//
//  ProfileSurveyView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI

struct ProfileSurveyView: View {
    @State private var selectedGender: String? = nil
    @State private var showingAgeOptions = false
    @State private var selectedAge = "Age Range"
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            YouShopText("Tell us About yourself", size: 28, weight: .semiBold)
                .padding(.top, 48)
            
            VStack(alignment: .leading, spacing: 16) {
                YouShopText("Who do you shop for?", size: 24, weight: .regular)

                
                HStack(spacing: 16) {
                    genderButton("Men")
                    genderButton("Women")
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                YouShopText("How Old are you?", size: 24, weight: .regular)
                    
                
                Button(action: { showingAgeOptions.toggle() }) {
                    HStack {
                        YouShopText(selectedAge, size: 16)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                    .cornerRadius(12)
                }
            }
            
            Spacer()
            
            YouShopButton(
                title: "Finish",
                height: 56,
                cornerRadius: 28,
                action: {
                }
            )
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func genderButton(_ gender: String) -> some View {
        Button(action: { selectedGender = gender }) {
            Text(gender)
                .font(.custom("Metropolis-Medium", size: 16))
                .foregroundColor(selectedGender == gender ? .white : (colorScheme == .dark ? .white : .black))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    selectedGender == gender ?
                    Color(red: 0.44, green: 0.37, blue: 0.93) :
                    Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor)
                )
                .cornerRadius(25)
        }
    }
}
