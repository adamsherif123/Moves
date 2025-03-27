//
//  CircleChatViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/24/25.
//

import FirebaseAuth
import Firebase

class CircleChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    let circle: Circles
    
    init(circle: Circles) {
        self.circle = circle
        Task { fetchMessages() }
    }
    
    @MainActor
    func sendMessage() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let circleId = circle.id
        let messageId = NSUUID().uuidString
        
        let messageTimestamp = Timestamp(date: Date())
        
        let message = Message(id: messageId,
                              fromId: currentUid,
                              groupId: circleId,
                              messageText: messageText,
                              timestamp: messageTimestamp)
        
        guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
        
        try? await
        Firestore.firestore().collection("circles").document(circleId)
            .collection("messages").document(messageId).setData(encodedMessage)
        
        var messageData = [String: Any]()
        
        messageData["lastMessage"] = messageText
        messageData["lastMessageTimestamp"] = messageTimestamp
        
        self.messageText = ""
        
        try await Firestore.firestore().collection("circles").document(circleId)
            .updateData(messageData)
        
    }
    
    func fetchMessages() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let circleId = circle.id
        
        let query = Firestore.firestore()
            .collection("circles")
            .document(circleId)
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
                DispatchQueue.main.async {
                    self.messages.append(contentsOf: messages)
                }
            }
        }
    }
}
