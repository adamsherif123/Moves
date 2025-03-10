//
//  EventService.swift
//  Moves
//
//  Created by Adam Sherif on 3/7/25.
//

import Firebase
import FirebaseFirestore

struct EventService {
    static func fetchEvents(forUserId userId: String) async throws -> [Event] {
        let db = Firestore.firestore()
        
        let ownerSnapshot = try await db.collection("events")
            .whereField("ownerUid", isEqualTo: userId)
            .getDocuments()
        let ownerEvents = ownerSnapshot.documents.compactMap { try? $0.data(as: Event.self) }
        
        let invitedSnapshot = try await db.collection("events")
            .whereField("invitesUids", arrayContains: userId)
            .getDocuments()
        let invitedEvents = invitedSnapshot.documents.compactMap { try? $0.data(as: Event.self) }
        
        var allEvents = ownerEvents
        for event in invitedEvents {
            if !allEvents.contains(where: { $0.id == event.id }) {
                allEvents.append(event)
            }
        }
        
        for i in 0 ..< allEvents.count {
            let event = allEvents[i]
            let ownerUid = event.ownerUid
            let eventUser = try await UserService.fetchUser(withUid: ownerUid)
            allEvents[i].user = eventUser
        }
        
        return allEvents
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
}

