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
        Task { try await fetchMessages() }
    }
    
    @MainActor
    func sendMessage() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let groupId = event.id
        let messageId = NSUUID().uuidString
        
        var messageTimestamp = Timestamp(date: Date())
        
        let message = Message(id: messageId,
                              fromId: currentUid,
                              groupId: groupId,
                              messageText: messageText,
                              timestamp: messageTimestamp)
        
        guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
        
        try? await
            Firestore.firestore().collection("events").document(groupId)
            .collection("messages").document(messageId).setData(encodedMessage)
        
        self.messageText = event.lastMessage ?? ""
        messageTimestamp = event.lastMessageTimestamp ?? Timestamp(date: Date())
        
        self.messageText = ""
    }
    
    @MainActor
    func fetchMessages() async throws {
        let messages = try await MessageService.fetchMessages(forEvent: event)
        self.messages = messages
    }
}
