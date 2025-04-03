//
//  User.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 10/03/2025.
//

import Foundation
import FirebaseAuth

struct User: Codable {
    let id: String
    let email: String
    let name: String
    
    init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
    
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.name = firebaseUser.displayName ?? ""
    }
}
