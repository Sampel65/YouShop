//
//  AuthViewModel.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 10/03/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var error: Error?
    @Published var isLoading = false
    private let db = Firestore.firestore()
    
    private var userDetailsCache: [String: [String: Any]] = [:]
    
    func signUp(email: String, password: String, name: String, phone: String, address: String, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        
        guard isValidEmail(email) else {
            isLoading = false
            completion(false, "Invalid email format")
            return
        }
        
        guard isValidPhone(phone) else {
            isLoading = false
            completion(false, "Invalid phone number")
            return
        }
        
        Task {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                try await saveUserData(userId: result.user.uid, email: email, name: name, phone: phone, address: address)
                completion(true, "Account created successfully!")
            } catch {
                isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    private func saveUserData(userId: String, email: String, name: String, phone: String, address: String) async throws {
        let userRef = db.collection("users").document(userId)
        let personalDetailsRef = userRef.collection("personal_details").document("profile")
        
        let userData: [String: Any] = [
            "id": userId,
            "email": email,
            "name": name,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        let personalDetails: [String: Any] = [
            "name": name,
            "email": email,
            "phone": phone,
            "address": address,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        let batch = db.batch()
        batch.setData(userData, forDocument: userRef)
        batch.setData(personalDetails, forDocument: personalDetailsRef)
        
        try await batch.commit()
        self.userDetailsCache[userId] = personalDetails
        
        let user = User(id: userId, email: email, name: name)
        self.user = user
        self.isAuthenticated = true
        self.isLoading = false
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        
        Task {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                self.user = User(from: result.user)
                self.isAuthenticated = true
                self.isLoading = false
                completion(true, "Successfully logged in")
            } catch {
                self.isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                isLoading = false
                completion(true, "Password reset email sent successfully")
            } catch {
                isLoading = false
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func fetchUserDetails(userId: String, completion: @escaping ([String: Any]?, String?) -> Void) {
        if let cachedDetails = userDetailsCache[userId] {
            completion(cachedDetails, nil)
            return
        }
        
        let personalDetailsRef = db.collection("users").document(userId).collection("personal_details").document("profile")
        
        Task {
            do {
                let document = try await personalDetailsRef.getDocument()
                if let data = document.data() {
                    self.userDetailsCache[userId] = data
                    completion(data, nil)
                } else {
                    completion(nil, "Personal details not found")
                }
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^\\d{10,}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    private func handleAuthError(_ error: Error, completion: @escaping (Bool, String) -> Void) {
        self.isLoading = false
        let authError = error as NSError
        
        switch authError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            completion(false, "Email is already in use")
        case AuthErrorCode.invalidEmail.rawValue:
            completion(false, "Invalid email format")
        case AuthErrorCode.weakPassword.rawValue:
            completion(false, "Password is too weak")
        default:
            completion(false, error.localizedDescription)
        }
    }
}
