//
//  UserService.swift
//  Moves
//
//  Created by Adam Sherif on 3/1/25.
//

import Foundation
import Firebase
import FirebaseAuth

struct UserService {
    
    static func fetchAllUsers() async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchUserFriends(withUid uid: String) async throws -> [User] {
        
        let friendDocs = try await Firestore.firestore().collection("users")
            .document(uid).collection("friends").getDocuments()
        
        var friends: [User] = []
        
        for doc in friendDocs.documents {
            let friendUid = doc.documentID
            let friend = try await fetchUser(withUid: friendUid)
            friends.append(friend)
        }
        return friends
    }
}
