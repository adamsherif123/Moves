//
//  Circles.swift
//  Moves
//
//  Created by Adam Sherif on 3/11/25.
//

import Firebase

struct Circles: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var userIds: [String]
    var lastMessage: String
    var lastMessageTimestamp: Timestamp
    var imageUrl: String?
}
