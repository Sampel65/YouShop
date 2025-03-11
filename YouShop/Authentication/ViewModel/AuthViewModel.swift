
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

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var error: String?
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
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleAuthError(error, completion: completion)
                return
            }
            
            guard let firebaseUser = result?.user else {
                self.isLoading = false
                completion(false, "Failed to create user")
                return
            }
            
            self.saveUserData(userId: firebaseUser.uid, email: email, name: name, phone: phone, address: address, completion: completion)
        }
    }
    
    private func saveUserData(userId: String, email: String, name: String, phone: String, address: String, completion: @escaping (Bool, String) -> Void) {
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
        
        batch.commit { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            
            self.userDetailsCache[userId] = personalDetails
            
            let user = User(id: userId, email: email, name: name)
            DispatchQueue.main.async {
                self.user = user
                self.isAuthenticated = true
                completion(true, "Account created successfully!")
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleAuthError(error, completion: completion)
                return
            }
            
            guard let firebaseUser = result?.user else {
                self.isLoading = false
                completion(false, "Failed to sign in")
                return
            }
            
            self.db.collection("users").document(firebaseUser.uid).getDocument { [weak self] document, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                
                if let document = document, document.exists,
                   let userData = document.data(),
                   let email = userData["email"] as? String,
                   let name = userData["name"] as? String {
                    let user = User(id: firebaseUser.uid, email: email, name: name)
                    self.user = user
                    self.isAuthenticated = true
                    completion(true, "Login successful!")
                } else {
                    completion(false, "User data not found")
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func fetchUserDetails(userId: String, completion: @escaping ([String: Any]?, String?) -> Void) {
        if let cachedDetails = userDetailsCache[userId] {
            completion(cachedDetails, nil)
            return
        }
        
        let personalDetailsRef = db.collection("users").document(userId).collection("personal_details").document("profile")
        
        personalDetailsRef.getDocument { [weak self] document, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            if let document = document, document.exists, let data = document.data() {
                // Update cache
                self?.userDetailsCache[userId] = data
                completion(data, nil)
            } else {
                completion(nil, "Personal details not found")
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
