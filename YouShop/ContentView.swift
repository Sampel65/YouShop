//
//  ContentView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 10/03/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(CartManager.shared)
}
