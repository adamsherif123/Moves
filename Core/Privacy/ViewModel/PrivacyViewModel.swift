//
//  PrivacyViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/25/25.
//

import FirebaseAuth
import Firebase

class PrivacyViewModel: ObservableObject {
    @Published var friends = [User]()
    @Published var isOffTheGrid: Bool
    @Published var isClose = false
    @Published var isCasual = true
    @Published var isGhosting = false
    
    let user: User
    
    init(user: User) {
        self.user = user
        self.isOffTheGrid = user.isMapPrivate
        Task { try await fetchFriends() }
    }
    
    @MainActor
    func fetchFriends() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        var allFriends = [User]()
        
        let casualDocs = try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("casualFriends")
            .getDocuments()
        
        for doc in casualDocs.documents {
            let friendUid = doc.documentID
            var friend = try await UserService.fetchUser(withUid: friendUid)
            friend.privacyType = "casual"
            allFriends.append(friend)
        }
        
        let closeDocs = try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("closeFriends")
            .getDocuments()
        
        for doc in closeDocs.documents {
            let friendUid = doc.documentID
            var friend = try await UserService.fetchUser(withUid: friendUid)
            friend.privacyType = "close"
            allFriends.append(friend)
        }
        
        let ghostDocs = try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("ghostFriends")
            .getDocuments()
        
        for doc in ghostDocs.documents {
            let friendUid = doc.documentID
            var friend = try await UserService.fetchUser(withUid: friendUid)
            friend.privacyType = "ghost"
            allFriends.append(friend)
        }
        
        self.friends = allFriends
    }
    
    
    func toggleOffTheGrid() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .updateData(["isMapPrivate": isOffTheGrid])
    }
    
    func makeCloseFriend(friend: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("casualFriends")
            .document(friend.id)
            .delete()
        
        try? await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("ghostFriends")
            .document(friend.id)
            .delete()
        
        try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("closeFriends")
            .document(friend.id)
            .setData([:])
        
        if let i = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[i].privacyType = "close"
        }
    }
    
    func makeCasualFriend(friend: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try? await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("closeFriends")
            .document(friend.id)
            .delete()
        
        try? await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("ghostFriends")
            .document(friend.id)
            .delete()
        
        try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("casualFriends")
            .document(friend.id)
            .setData([:])
        
        if let i = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[i].privacyType = "casual"
        }
    }
    
    func makeGhostFriend(friend: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try? await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("closeFriends")
            .document(friend.id)
            .delete()
        
        try? await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("casualFriends")
            .document(friend.id)
            .delete()
        
        try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("ghostFriends")
            .document(friend.id)
            .setData([:])
        
        if let i = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[i].privacyType = "ghost"
        }
    }
}
