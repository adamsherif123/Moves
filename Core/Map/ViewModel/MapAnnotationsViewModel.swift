//
//  MapAnnotationsViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 2/24/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class MapAnnotationsViewModel: ObservableObject {
    
    @Published var user: User
    
    @Published var events: [Event] = []
    @Published var users: [User] = []
    
    private var eventListener: ListenerRegistration?
    
    
    
    init(user: User) {
        self.user = user
        Task { await startListeningToInvitedEvents(forUserId: user.id) }
    }
    
    @MainActor
    func fetchUserEvents() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        self.events = try await EventService.fetchEvents(forUserId: currentUid)
    }
    
    @MainActor
    func startListeningToInvitedEvents(forUserId userId: String) {
        let db = Firestore.firestore()
        
        eventListener?.remove()
        
        eventListener = db.collection("events")
            .whereField("invitesUids", arrayContains: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let snapshot = snapshot else {
                    print("DEBUG: Error listening to events: \(String(describing: error))")
                    return
                }
                
                Task {
                    var updatedEvents: [Event] = []
                    
                    for doc in snapshot.documents {
                        do {
                            var event = try doc.data(as: Event.self)
                            let ownerUid = event.ownerUid
                            let eventUser = try await UserService.fetchUser(withUid: ownerUid)
                            event.user = eventUser
                            updatedEvents.append(event)
                        } catch {
                            print("DEBUG: Error decoding event: \(error)")
                        }
                    }
                    
                    self?.events = updatedEvents
                    
                }
            }
    }
    
    func stopListening() {
        eventListener?.remove()
        eventListener = nil
    }
    
    @MainActor
    func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        var friends = try await UserService.fetchUserFriends(withUid: currentUid)
        let currentUser = try await UserService.fetchUser(withUid: currentUid)
        friends.append(currentUser)
        
        self.users = friends
    }
}









