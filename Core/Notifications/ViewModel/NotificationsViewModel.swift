//
//  NotificationsViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/5/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

class NotificationsViewModel: ObservableObject {
    
    @Published var friendRequests: [Notification] = []
    @Published var invitedEvents: [Event] = []
    
    func loadFriendRequests(for userId: String) {
        Task {
            do {
                let requests = try await NotificationService.fetchFriendRequests(for: userId)
                await MainActor.run {
                    self.friendRequests = requests
                }
            } catch {
                print("DEBUG: Error fetching friend requests: \(error)")
            }
        }
    }
    
    
    func aceeptFriendRequest(_ request: Notification) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try? await Firestore.firestore().collection("users").document(currentUid)
            .collection("friends").document(request.senderId).setData([:])
        
        try? await Firestore.firestore().collection("users")
            .document(request.senderId)
            .collection("friends")
            .document(currentUid)
            .setData([:])
        
        try await Firestore.firestore().collection("users")
            .document(currentUid)
            .collection("casualFriends")
            .document(request.senderId)
            .setData([:])
        
        try await Firestore.firestore().collection("users")
            .document(request.senderId).collection("casualFriends")
            .document(currentUid).setData([:])
        
        try await deleteFriendRequest(request)
    }
    
    
    func deleteFriendRequest(_ request: Notification) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try? await Firestore.firestore().collection("users")
            .document(currentUid)
            .collection("notifications")
            .document(request.senderId)
            .delete()
        
        await MainActor.run {
            self.friendRequests.removeAll { $0.id == request.id }
        }
    }
    
    @MainActor
    func loadInvites() async throws {
        let invites = try await NotificationService.fetchInvitations()
        
        var updatedEvents: [Event] = []
        
        for invite in invites {
            var updatedInvite = invite
            let eventUser = try await UserService.fetchUser(withUid: updatedInvite.ownerUid)
            updatedInvite.user = eventUser
            updatedEvents.append(updatedInvite)
        }
        
        self.invitedEvents = updatedEvents
    }
}
