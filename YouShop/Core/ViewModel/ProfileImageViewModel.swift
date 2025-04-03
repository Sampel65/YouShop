//
//  ProfileImageViewModel.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 11/03/2025.
//

import SwiftUI
import UIKit

class ProfileImageViewModel: ObservableObject {
    @Published var profileImage: Image?
    @Published var uiImage: UIImage?
    
    static let shared = ProfileImageViewModel()
    
    private init() {}
    
    func updateProfileImage(_ uiImage: UIImage) {
        DispatchQueue.main.async {
            self.uiImage = uiImage
            self.profileImage = Image(uiImage: uiImage)
        }
    }
    
    func loadImageData(_ data: Data) {
        guard let uiImage = UIImage(data: data) else { return }
        DispatchQueue.main.async {
            self.uiImage = uiImage
            self.profileImage = Image(uiImage: uiImage)
        }
    }
}
