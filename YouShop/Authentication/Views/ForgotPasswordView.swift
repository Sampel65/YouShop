import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header Image
                Image("youshop_logo1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 20)
                
                // Title
                YouShopText("Forgot Password", size: 15, weight: .semiBold)
                    .padding(.bottom)
                
                // Description
                YouShopText("Enter your email address to reset your password", size: 14)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 32)
                
                // Email TextField
                YouShopTextTextfield(
                    title: "Email",
                    text: $email,
                    placeholder: "Enter your email",
                    isSecure: false
                )
                
                Spacer()
                
                // Reset Password Button
                YouShopButton(
                    title: "Reset Password",
                    loadingTitle: "Sending...",
                    isLoading: viewModel.isLoading,
                    height: 56,
                    cornerRadius: 28,
                    action: {
                        viewModel.resetPassword(email: email) { success, message in
                            alertTitle = success ? "Success" : "Error"
                            alertMessage = message
                            showAlert = true
                        }
                    }
                )
                .disabled(email.isEmpty || !email.contains("@"))
                .padding(.bottom, 16)
                
                // Back to Login Button
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        YouShopText("Remember your password?", size: 14)
                            .foregroundColor(.gray)
                        YouShopText("Log In", size: 14, weight: .medium)
                            .foregroundColor(Color(AppColor.primaryColor))
                    }
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 16)
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle).afacadFont(16, weight: .bold),
                    message: Text(alertMessage).afacadFont(14, weight: .regular),
                    dismissButton: .default(Text("OK")) {
                        if alertTitle == "Success" {
                            dismiss()
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
