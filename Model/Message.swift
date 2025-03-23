//
//  Message.swift
//  Moves
//
//  Created by Adam Sherif on 3/22/25.
//

import Firebase

struct Message: Identifiable, Codable {
    let id: String
    let fromId: String
    let groupId: String
    let messageText: String
    let timestamp: Timestamp
    
    var user: User?
}
