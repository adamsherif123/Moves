//
//  ChatViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/22/25.
//

import Foundation
import Firebase
import FirebaseAuth

class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var messageText = ""
    
    let event: Event
    
    init(event: Event) {
        self.event = event
        Task { await fetchMessages() }
    }
    
    @MainActor
    func sendMessage() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let groupId = event.id
        let messageId = NSUUID().uuidString
        
        let messageTimestamp = Timestamp(date: Date())
        
        let message = Message(id: messageId,
                              fromId: currentUid,
                              groupId: groupId,
                              messageText: messageText,
                              timestamp: messageTimestamp)
        
        guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
        
        try? await
        Firestore.firestore().collection("events").document(groupId)
            .collection("messages").document(messageId).setData(encodedMessage)
        
        var messageData = [String: Any]()
        
        messageData["lastMessage"] = messageText
        messageData["lastMessageTimestamp"] = messageTimestamp
        
        try await Firestore.firestore().collection("events").document(groupId)
            .updateData(messageData)
        
        self.messageText = ""
    }
    
    @MainActor
    func fetchMessages() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let groupId = event.id
        
        let query = Firestore.firestore()
            .collection("events")
            .document(groupId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            var messages = changes.compactMap { try? $0.document.data(as: Message.self) }
            
            Task {
                for i in 0 ..< messages.count {
                    let message = messages[i]
                    if message.fromId != currentUid {
                        let fetchedUser = try await UserService.fetchUser(withUid: message.fromId)
                        messages[i].user = fetchedUser
                    }
                }
                
                self.messages.append(contentsOf: messages)
                
            }
        }
    }
}
