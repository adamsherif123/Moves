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
    
    @Published var events: [Event] = []
    @Published var invitedUsers: [User] = []
    
    private var eventListeners: [ListenerRegistration] = []
    
    static let shared = MapAnnotationsViewModel()
    
    @MainActor
    func fetchUserEvents() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        self.events = try await EventService.fetchEvents(forUserId: currentUid)
    }
    
    deinit {
        eventListeners.forEach { $0.remove() }
    }
    
    @MainActor
    func fetchInvitedUsers(eventId: String) async throws {
        let invitedUsers = try await EventService.fetchInvitedUsers(forEventId: eventId)
        self.invitedUsers = invitedUsers
    }
}







