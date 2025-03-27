//
//  User.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import Foundation
import FirebaseAuth

struct User: Identifiable, Codable, Hashable {
    var id: String
    let email: String
    var username: String
    var fullName: String
    var profileImageUrl: String
    var isCalendarPrivate: Bool
    var isMapPrivate: Bool
    var circlesCount: Int
    var friendsCount: Int
    var latitude: Double?
    var longitude: Double?
    var dob: String?
    var gender: String?
    var privacyType: String?
    
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == id
    }
}
