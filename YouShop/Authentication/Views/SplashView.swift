//
//  SplashView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 10/03/2025.
//

import SwiftUI

///SplashView displays the app's loading screen with optimized memory management
struct SplashView: View {
    
    @State private var isActive: Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
 
    private let animationDuration: Double = 1.2
    private let navigationDelay: Double = 5.0

    var body: some View {
        NavigationStack {
            ZStack {
                Color("blues").ignoresSafeArea()
                VStack {
                    Image("youshop_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 460, maxHeight: 550)
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: animationDuration)) {
                                self.size = 0.9
                                self.opacity = 1.0
                            }
                        }
                }
                .task {
                    try? await Task.sleep(for: .seconds(navigationDelay))

                    if !Task.isCancelled {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $isActive) {
                LoginView()
            }
        }
    }
}

