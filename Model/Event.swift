//
//  Event.swift
//  Moves
//
//  Created by Adam Sherif on 2/24/25.
//
import Foundation
import Firebase

struct Event: Identifiable, Codable, Hashable {
    var id: String
    var emoji: String
    var title: String
    var description: String?
    var time: Timestamp?
    var locationTitle: String?
    var latitude: Double?
    var longitude: Double?
    var ownerUid: String
    var createdAt: Timestamp?
    var invitesUids: [String] = []
    var user: User?
}

