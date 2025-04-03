//
//  LoginView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 10/03/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var email = ""
    @State private var password = ""
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State private var isInputValid = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var navigateToMainView = false
    
    var body: some View {
        NavigationStack {
            VStack {

                VStack(alignment: .leading, spacing: 8) {
                    Image("youshop_logo1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120,  height: 120)
                        .padding(.bottom, 20)
                    
                    YouShopText("Welcome Back", size: 18, weight: .semiBold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 32)

                VStack(spacing: 24) {
                    YouShopTextTextfield(
                        title: "Email",
                        text: $email,
                        placeholder: "Enter your email",
                        isSecure: false
                    )
                    
                    YouShopTextTextfield(
                        title: "Password",
                        text: $password,
                        placeholder: "Enter your password",
                        isSecure: true
                    )
                    
                    Button(action: {}) {
                        Text("Forgot password")
                            .underline()
                            .font(.custom("Metropolis-Regular", size: 14))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Spacer()

                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        socialSignInButton(service: "Google")
                        socialSignInButton(service: "Apple")
                    }
                    
                    HStack {
                        VStack {
                            Divider()
                        }
                        Text("Or")
                            .afacadFont(14, weight: .regular)
                            .foregroundColor(.gray)
                        VStack{
                            Divider()
                        }
                    }
                    
                    YouShopButton(
                        title: "Log In",
                        loadingTitle: "Logging in...",
                        isLoading: viewModel.isLoading,
                        height: 56,
                        cornerRadius: 28,
                        action: {
                            viewModel.signIn(email: email, password: password) { success, message in
                                alertTitle = success ? "Success" : "Error"
                                alertMessage = message
                                if success {
                                    navigateToMainView = true
                                } else {
                                    showAlert = true
                                }
                            }
                        }
                    )
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    HStack(spacing: 4) {
                        YouShopText("Don't have an account?", size: 14)
                            .foregroundColor(.gray)
                        NavigationLink("Sign Up") {
                            SignUpView()
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.bottom, 32)
                
               
            }
            .padding(.horizontal, 16)
            .navigationBarHidden(true)
            .overlay(Group {
                if viewModel.isLoading {
                    ProgressView()
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle).font(.custom("Metropolis-Bold", size: 16)),
                    message: Text(alertMessage).font(.custom("Metropolis-Regular", size: 14)),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(isPresented: $navigateToMainView) {
                MainTabView().navigationBarBackButtonHidden()
            }
        }
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
                    .font(.custom("Metropolis-Regular", size: 16))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color(colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 1, green: 1, blue: 1)))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color( colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor), lineWidth: 2)
            )
        }
    }
}

#Preview {
    LoginView()
}
