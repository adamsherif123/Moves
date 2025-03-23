//
//  EventService.swift
//  Moves
//
//  Created by Adam Sherif on 3/7/25.
//

import Firebase
import FirebaseFirestore

struct EventService {
    
    private static var listener: ListenerRegistration?

    static func fetchEvents(forUserId userId: String) async throws -> [Event] {
        let db = Firestore.firestore()
        
        let invitedSnapshot = try await db.collection("events")
            .whereField("invitesUids", arrayContains: userId)
            .getDocuments()
        var invitedEvents = invitedSnapshot.documents.compactMap { try? $0.data(as: Event.self) }
        
        for i in 0 ..< invitedEvents.count {
            let event = invitedEvents[i]
            let ownerUid = event.ownerUid
            let eventUser = try await UserService.fetchUser(withUid: ownerUid)
            invitedEvents[i].user = eventUser
        }
        
        var userEvents: [Event] = []
        
        listener = db.collection("events")
            .whereField("invitesUids", arrayContains: userId)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else { return }
                userEvents = invitedEvents
            }
        
        return userEvents
    }
    
    static func fetchInvitedUsers(forEventId eventId: String) async throws -> [User] {
        let db = Firestore.firestore()
        
        let documentSnapshot = try await db.collection("events").document(eventId).getDocument()
        guard let eventData = documentSnapshot.data(),
              let invitedUids = eventData["invitesUids"] as? [String] else {
            return []
        }
        
        return try await withThrowingTaskGroup(of: User?.self) { group in
            for uid in invitedUids {
                group.addTask {
                    try await UserService.fetchUser(withUid: uid)
                }
            }
            
            var users: [User] = []
            for try await user in group {
                if let user = user {
                    users.append(user)
                }
            }
            return users
        }
    }
    
    static func fetchRSVPdUids(forEventId eventId: String) async throws -> [String] {
        let db = Firestore.firestore()
        
        let rsvpedSnapshot = try await db
            .collection("events")
            .document(eventId)
            .collection("rsvpedUsers")
            .getDocuments()
        
        let rsvpedUids: [String] = rsvpedSnapshot.documents.map { $0.documentID }
        
        return rsvpedUids
    }
    
    static func fetchEvent(forEventId eventId: String) async throws -> Event {
        let eventSnapshot = try await Firestore.firestore().collection("events").document(eventId).getDocument()
        
        let event = try eventSnapshot.data(as: Event.self)
        
        return event
    }
}
