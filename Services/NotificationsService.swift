//
//  NotificationsService.swift
//  Moves
//
//  Created by Adam Sherif on 3/6/25.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth

struct NotificationService {
    
    static func fetchFriendRequests(for userId: String) async throws -> [Notification] {
       
        let snapshot = try await Firestore.firestore().collection("users").document(userId).collection("notifications")
            .whereField("type", isEqualTo: "friendRequest").getDocuments()
        
        var requests = try snapshot.documents.compactMap({ try $0.data(as: Notification.self) })
        
        for i in 0 ..< requests.count {
            let request = requests[i]
            let senderUid = request.senderId
            let senderUser = try await UserService.fetchUser(withUid: senderUid)
            requests[i].user = senderUser
        }
        
        return requests
    }
    
    static func fetchInvitations() async throws -> [Event] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .collection("invitedEvents")
            .getDocuments()
        
        let inviteIds = snapshot.documents.map { $0.documentID }
        
        var invitedEvents: [Event] = []
        for inviteId in inviteIds {
            let event = try await EventService.fetchEvent(forEventId: inviteId)
            invitedEvents.append(event)
        }
        
        return invitedEvents
    }
}

