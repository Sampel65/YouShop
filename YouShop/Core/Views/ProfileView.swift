//
//  ProfileView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//


import SwiftUI
import Firebase

struct ProfileView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @EnvironmentObject private var profileImageVM: ProfileImageViewModel
    @State private var showImagePicker = false
    @Environment(\.colorScheme) var colorScheme
    @State private var userDetails: [String: Any]? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Profile Section
                VStack(spacing: 12) {
                    profileImageSection
                    userInfoSection
                }
                .padding(.top)

                // Menu Items
                menuSection
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                Spacer()
                
                // Sign Out Button
                signOutButton
            }
            .padding()
            .onAppear(perform: loadUserDetails)
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: Binding(
                get: { profileImageVM.uiImage },
                set: { newImage in
                    if let newImage = newImage {
                        profileImageVM.updateProfileImage(newImage)
                    }
                }
            ))
        }
    }
    
    private var profileImageSection: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
            
            if let profileImage = profileImageVM.profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
            }
            
            Button(action: { showImagePicker = true }) {
                Image(systemName: "camera.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 24))
                    .foregroundColor(Color(AppColor.primaryColor))
                    .background(Color.white)
                    .clipShape(Circle())
                    .position(x: 60, y: 60)
            }
        }
    }
    
    private var userInfoSection: some View {
        VStack(spacing: 4) {
            Text(authViewModel.user?.name ?? "")
                .font(.title3)
                .fontWeight(.medium)
            
            Text(authViewModel.user?.email ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if let userDetails = userDetails {
                Text(userDetails["phone"] as? String ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(userDetails["address"] as? String ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
    
    private var menuSection: some View {
        VStack(spacing: 2) {
            ForEach(["Address", "Wishlist", "Payment", "Help", "Support"], id: \.self) { item in
                menuButton(item)
                if item != "Support" {
                    Divider()
                }
            }
        }
    }
    
    private var signOutButton: some View {
        Button(action: { authViewModel.signOut() }) {
            Text("Sign Out")
                .font(.headline)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
    }
    
    private func menuButton(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.body)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(colorScheme == .dark ? Color.black : .white)
    }
    
    private func loadUserDetails() {
        guard let userId = authViewModel.user?.id else { return }
        isLoading = true
        
        authViewModel.fetchUserDetails(userId: userId) { details, error in
            isLoading = false
            if let error = error {
                errorMessage = error
            } else {
                userDetails = details
            }
        }
    }
}
