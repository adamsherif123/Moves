//
//  CirlcesService.swift
//  Moves
//
//  Created by Adam Sherif on 3/24/25.
//

import Firebase
import FirebaseFirestore

struct CirlcesService {
    private static var listener: ListenerRegistration?

    static func fetchCircles(forUserId userId: String) async throws -> [Circles] {
        let db = Firestore.firestore()
        
        let circlesSnapshot = try await db.collection("circles")
            .whereField("userIds", arrayContains: userId)
            .getDocuments()
        let userCircles = circlesSnapshot.documents.compactMap { try? $0.data(as: Circles.self) }
        
//        var circles: [Circles] = []
        
//        listener = db.collection("circles")
//            .whereField("userIds", arrayContains: userId)
//            .addSnapshotListener { snapshot, error in
//                guard let snapshot = snapshot else { return }
//                circles = userCircles
//            }
        
        return userCircles
    }
}
