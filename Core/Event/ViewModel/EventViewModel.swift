//
//  EventViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/9/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class EventViewModel: ObservableObject {
    @Published var isRSVPd: Bool?
    
    @MainActor
    func rsvp(eventId: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try? await Firestore.firestore().collection("events")
            .document(eventId).collection("rsvpedUsers").document(currentUid).setData([:])
        
        withAnimation {
            self.isRSVPd = true
        }
    }
    
    @MainActor
    func unrsvp(eventId: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try? await Firestore.firestore().collection("events")
            .document(eventId).collection("rsvpedUsers").document(currentUid).delete()
        
        withAnimation {
            self.isRSVPd = false
        }
    }
    
    @MainActor
    func checkIfRSVPd(eventId: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let rsvp = try? await Firestore.firestore().collection("events").document(eventId).collection("rsvpedUsers").document(currentUid).getDocument()
        
        if rsvp?.exists == true {
            withAnimation {
                self.isRSVPd = true
            }
        } else {
            withAnimation {
                self.isRSVPd = false
            }
        }
    }
}
