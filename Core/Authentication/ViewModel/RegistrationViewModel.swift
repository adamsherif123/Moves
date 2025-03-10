//
//  RegistrationViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/1/25.
//

import Foundation
import PhotosUI
import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var month = ""
    @Published var day = ""
    @Published var year = ""
    @Published var isMale: Bool = false
    @Published var isFemale: Bool = false
    @Published var isOther: Bool = false
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    @Published var profileImage: Image?
    
    private var uiImage: UIImage?
    
    private var imageUrl: String = ""
    
    @MainActor
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }

        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImagee = UIImage(data: data) else { return }
        self.uiImage = uiImagee
        print("let uiImage is \(uiImagee)")
        print("self.uiImage is \(self.uiImage)")
        
        self.profileImage = Image(uiImage: uiImagee)
    }
    
    @MainActor
    func createUser() async throws {
        
        let dob = computeDob()
        let gender = computeGender()
        
        if let uiImage = uiImage {
            print("Entered UIImage upload")
            self.imageUrl = try await ImageUploader.uploadImage(image: uiImage)
            print("DEBUG: Uploaded image URL: \(imageUrl)")
        }
        
        try await AuthService.shared.createUser(
            withEmail: email,
            username: username,
            password: password,
            profileImageUrl: imageUrl,
            fullname: fullname,
            dob: dob,
            gender: gender
        )
        
        resetFields()
        
    }
    
    func computeDob() -> String {
        return "\(month)/\(day)/\(year)"
    }
    
    func computeGender() -> String {
        if isMale {
            return "Male"
        } else if isFemale {
            return "Female"
        } else if isOther {
            return "Other"
        } else {
            return "Unspecified"
        }
    }
    
    func resetFields() {
        email = ""
        username = ""
        password = ""
        fullname = ""
        month = ""
        day = ""
        year = ""
        isMale = false
        isFemale = false
        isOther = false
    }
}
