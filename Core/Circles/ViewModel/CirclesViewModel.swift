//
//  CirclesViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/24/25.
//

import Firebase
import FirebaseAuth
import PhotosUI
import SwiftUI

class CirclesViewModel: ObservableObject {
    @Published var friends: [User] = []
    @Published var selectedFriends: [User] = []
    @Published var circleName = ""
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    @Published var cirleImage: Image?
    
    private var uiImage: UIImage?
    private var imageUrl: String?
    
    @MainActor
    func fetchFriends() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let userFriends = try await UserService.fetchUserFriends(withUid: currentUid)
        
        self.friends = userFriends
    }
    
    func createCircle() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        var friendsIds = selectedFriends.map { $0.id }
        friendsIds.append(currentUid)
        
        let circleId = NSUUID().uuidString
        
        if let uiImage = uiImage {
            print("Entered UIImage upload")
            self.imageUrl = try await ImageUploader.uploadImage(image: uiImage)
        }
        
        await uploadCircleData(id: circleId, name: circleName, userIds: friendsIds, lastMessage: "New Circle. Say Hi!", lastMessageTimestamp: Timestamp(date: .now), imageUrl: imageUrl)
        
        
    }
    
    func uploadCircleData(id: String,
                          name: String,
                          userIds: [String],
                          lastMessage: String,
                          lastMessageTimestamp: Timestamp,
                          imageUrl: String?) async {
        
        let circle = Circles(id: id, name: name, userIds: userIds, lastMessage: lastMessage, lastMessageTimestamp: lastMessageTimestamp, imageUrl: imageUrl)
        
        guard let encodedCircle = try? Firestore.Encoder().encode(circle) else { return }
        
        try? await
            Firestore.firestore()
            .collection("circles")
            .document(circle.id)
            .setData(encodedCircle)
    }
    
    @MainActor
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }

        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.cirleImage = Image(uiImage: uiImage)
    }
}
