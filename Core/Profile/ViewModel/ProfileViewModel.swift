//
//  ProfileViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/5/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth


class ProfileViewModel: ObservableObject {

    private let db = Firestore.firestore()
    
    private var listener: ListenerRegistration?
    private var eventListeners: [ListenerRegistration] = []
    
    @Published var isFriendFreindRequestSent: Bool?
    @Published var isFriend: Bool?
    @Published var didUserSendMeRequest: Bool?
    @Published var friendsCount: Int = 0
    
    @Published var events: [Event] = []
    
    static let shared = ProfileViewModel()
    
    @MainActor
    func fetchUserEvents(uid: String) async throws {
        self.events = try await EventService.fetchEvents(forUserId: uid)
    }
    
    @MainActor
    func sendFriendRequest(to user: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No logged in user, can't send friend request.")
            return
        }
        
        let request = Notification(id: UUID().uuidString, senderId: currentUid, type: "friendRequest", timestamp: Timestamp(date: Date()), isAccepted: false)
        
        guard let encodedFriendRequest = try? Firestore.Encoder().encode(request) else {
            print("DEBUG: Failed to encode friend request.")
            return
        }
        
        try? await db.collection("users").document(user.id).collection("notifications").document(currentUid).setData(encodedFriendRequest)
        
        withAnimation {
            self.isFriendFreindRequestSent = true
        }
    }
    
    @MainActor
    func removeFriendRequest(to user: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No logged in user, can't remove friend request.")
            return
        }
        
        try? await db.collection("users")
            .document(user.id)
            .collection("notifications")
            .document(currentUid)
            .delete()
        
        withAnimation {
            self.isFriendFreindRequestSent = false
        }
    }
    
    @MainActor
    func checkIfFriendsOrIfRequested(for user: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let notification = try? await db.collection("users").document(user.id)
            .collection("notifications").document(currentUid).getDocument()
        
        let myNotificationDoc = try? await db.collection("users").document(currentUid)
            .collection("notifications").document(user.id).getDocument()
        
        let friends = try? await db.collection("users").document(user.id)
            .collection("friends").document(currentUid).getDocument()
        
        if notification?.exists == true {
            withAnimation {
                self.isFriendFreindRequestSent = true
            }
        } else {
            withAnimation {
                self.isFriendFreindRequestSent = false
            }
        }
        
        if myNotificationDoc?.exists == true {
            withAnimation {
                self.didUserSendMeRequest = true
            }
        } else {
            withAnimation {
                self.didUserSendMeRequest = false
            }
        }
        
        if friends?.exists == true {
            withAnimation {
                self.isFriend = true
            }
        } else {
            withAnimation {
                self.isFriend = false
            }
        }
    }
    
    @MainActor
    func unfriend(with user: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        try? await db.collection("users")
            .document(user.id)
            .collection("friends")
            .document(currentUid)
            .delete()

        try? await db.collection("users")
            .document(currentUid)
            .collection("friends")
            .document(user.id)
            .delete()

        withAnimation {
            self.isFriend = false
        }
    }
    
    func listenToFriendsCount(for user: User) {
        listener = db.collection("users")
            .document(user.id)
            .collection("friends")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let docs = snapshot?.documents else { return }
                DispatchQueue.main.async {
                    self?.friendsCount = docs.count
                }
            }
    }
    
    @MainActor
    func acceptFriendRequest(from user: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try? await Firestore.firestore().collection("users").document(currentUid)
            .collection("friends").document(user.id).setData([:])
        
        try? await Firestore.firestore().collection("users").document(user.id)
            .collection("friends").document(currentUid).setData([:])
        
        try? await Firestore.firestore().collection("users").document(currentUid)
            .collection("notifications").document(user.id).delete()
        
        withAnimation {
            self.isFriend = true
        }
    }
    
    func removeFriendsCountListener() {
        listener?.remove()
        listener = nil
    }
}
