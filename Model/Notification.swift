//
//  FriendRequest.swift
//  Moves
//
//  Created by Adam Sherif on 3/5/25.
//

import Firebase

struct Notification: Identifiable, Codable {
    let id: String
    let senderId: String
    let type: String
    let timestamp: Timestamp
    var isAccepted: Bool
    var user: User?
}
