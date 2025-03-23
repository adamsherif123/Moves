//
//  MessageService.swift
//  Moves
//
//  Created by Adam Sherif on 3/22/25.
//

import FirebaseAuth
import FirebaseFirestore

struct MessageService {
    static func fetchMessages(forEvent event: Event) async throws -> [Message] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let groupId = event.id
        
        let groupMessagesSnapshot = try await Firestore.firestore().collection("events").document(groupId).collection("messages").getDocuments()
        var messages = groupMessagesSnapshot.documents.compactMap { try? $0.data(as: Message.self) }
        
        for i in 0 ..< messages.count {
            let message = messages[i]
            if message.fromId != currentUid {
                let fetchedUser = try await UserService.fetchUser(withUid: message.fromId)
                messages[i].user = fetchedUser
            }
        }
        
        return messages
    }
}
