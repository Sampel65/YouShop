//
//  SignUpView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 10/03/2025.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phone = ""
    @State private var address = ""
    @FocusState private var isNameFocused: Bool
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isPhoneFocused: Bool
    @FocusState private var isAddressFocused: Bool
    @State private var showReferralCode = false
    @State private var referralCode = ""
    @State private var isInputValid = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Image("youshop_logo1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120,  height: 120)
                
                YouShopText("Create your account", size: 15, weight: .semiBold)
                    .padding(.top, 8)

                VStack(spacing: 15) {
                    YouShopTextTextfield(
                        title: "Name",
                        text: $name,
                        placeholder: "Enter your name",
                        isSecure: false,
                        isFocused: $isNameFocused
                    )
                    .onChange(of: name) { validateInputs() }

                    YouShopTextTextfield(
                        title: "Email",
                        text: $email,
                        placeholder: "Enter your email",
                        isSecure: false,
                        isFocused: $isEmailFocused
                    )
                    .onChange(of: email) { validateInputs() }

                    YouShopTextTextfield(
                        title: "Password",
                        text: $password,
                        placeholder: "Enter your password",
                        isSecure: true,
                        isFocused: $isPasswordFocused
                    )
                    .onChange(of: password) { validateInputs() }

                    YouShopTextTextfield(
                        title: "Phone",
                        text: $phone,
                        placeholder: "Enter your phone number",
                        isSecure: false,
                        isFocused: $isPhoneFocused
                    )
                    .onChange(of: phone) { validateInputs() }

                    YouShopTextTextfield(
                        title: "Address",
                        text: $address,
                        placeholder: "Enter your address",
                        isSecure: false,
                        isFocused: $isAddressFocused
                    )
                    .onChange(of: address) { validateInputs() }

                    Button(action: {
                        withAnimation {
                            showReferralCode.toggle()
                        }
                    }) {
                        Text("Enter Referral Code")
                            .underline()
                            .afacadFont(14, weight: .regular)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if showReferralCode {
                        YouShopTextTextfield(
                            title: "Referral Code",
                            text: $referralCode,
                            placeholder: "Enter referral code",
                            isSecure: false
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }

                Spacer()

                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        socialSignInButton(service: "Google")
                        socialSignInButton(service: "Apple")
                    }

                    YouShopText("Or", size: 14, weight: .regular)
                        .foregroundColor(.gray)

                    YouShopButton(
                        title: "Sign up",
                        loadingTitle: "Signing up...",
                        isLoading: viewModel.isLoading,
                        height: 56,
                        cornerRadius: 28,
                        action: {
                            viewModel.signUp(
                                email: email,
                                password: password,
                                name: name,
                                phone: phone,
                                address: address
                            ) { success, message in
                                alertTitle = success ? "Success" : "Error"
                                alertMessage = message
                                showAlert = true
                            }
                        }
                    )
                    .disabled(!isInputValid)

                    HStack(spacing: 4) {
                        YouShopText("Already have an account?", size: 14)
                            .foregroundColor(.gray)
                        NavigationLink("Log in", destination: LoginView())
                            .afacadFont(14, weight: .medium)
                            .foregroundColor(Color(AppColor.primaryColor))
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 24)
            .navigationBarHidden(true)
            .overlay(Group {
                if viewModel.isLoading {
                    ProgressView()
                }
            })
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle).afacadFont(16, weight: .bold),
                    message: Text(alertMessage).afacadFont(14, weight: .regular),
                    dismissButton: .default(Text("OK")) {
                        if alertTitle == "Success" {
                            navigateToLogin = true
                        }
                    }
                )
            }
        }
    }

    private func validateInputs() {
        isInputValid = !name.isEmpty && 
                      !email.isEmpty && 
                      !password.isEmpty && 
                      !phone.isEmpty && 
                      !address.isEmpty && 
                      phone.count >= 10 && 
                      email.contains("@") && 
                      email.contains(".") && 
                      password.count >= 6
    }

    @ViewBuilder
    private func socialSignInButton(service: String) -> some View {
        Button {

        } label: {
            HStack {
                Image(service.lowercased() == "google" ? service.lowercased() : colorScheme == .dark ? "appleWhite" : "appleBlack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(service)
                    .font(.custom("Metropolis-Medium", size: 16))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor), lineWidth: 2)
            )
        }
    }
}

#Preview {
    SignUpView()
}
