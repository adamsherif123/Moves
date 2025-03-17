//
//  EditProfileViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/2/25.
//

import PhotosUI
import SwiftUI
import Firebase


class EditProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    @Published var profileImage: Image?
    
    @Published var email = ""
    @Published var username = ""
    @Published var fullname = ""
    @Published var profileImageUrl = ""
    
    private var uiImage: UIImage?
    
    init(user: User) {
        self.user = user
        self.fullname = user.fullName
        self.profileImageUrl = user.profileImageUrl
        self.username = user.username
        self.email = user.email
    }
    
    
    
    @MainActor
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }

        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateUserData() async throws {
        
        var data = [String: Any]()
        
        if let uiImage = uiImage  {
            let imageUrl = try await ImageUploader.uploadImage(image: uiImage)
            data["profileImageUrl"] = imageUrl
        }
        
        if !fullname.isEmpty && user.fullName != fullname {
            data["fullName"] = fullname
        }
        
        if !email.isEmpty && user.email != email {
            data["email"] = email
        }
        
        if !username.isEmpty && user.username != username {
            data["username"] = username
        }
        
        if !data.isEmpty {
            try await Firestore.firestore().collection("users").document(user.id).updateData(data)
        }
    }
}
