//
//  NotificationsService.swift
//  Moves
//
//  Created by Adam Sherif on 3/6/25.
//

import Firebase
import FirebaseFirestore

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
}

