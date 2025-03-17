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
    @Published var event: Event
    @Published var isRSVPd: Bool?
    @Published var rsvpedUids: [String] = []
    @Published var invitedUsers: [User] = []
    
    init(event: Event) {
        self.event = event
    }
    
    
    @MainActor
    func rsvp() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try? await Firestore.firestore().collection("events")
            .document(event.id).collection("rsvpedUsers").document(currentUid).setData([:])
        
        withAnimation {
            self.isRSVPd = true
        }
    }
    
    @MainActor
    func unrsvp() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try? await Firestore.firestore().collection("events")
            .document(event.id).collection("rsvpedUsers").document(currentUid).delete()
        
        withAnimation {
            self.isRSVPd = false
        }
    }
    
    @MainActor
    func checkIfRSVPd() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let rsvp = try? await Firestore.firestore().collection("events").document(event.id).collection("rsvpedUsers").document(currentUid).getDocument()
        
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
    
    @MainActor
    func fetchRsvpedUids() async throws {
        let snapshot = try await Firestore.firestore()
            .collection("events")
            .document(event.id)
            .collection("rsvpedUsers")
            .getDocuments()
        
        let userIds = snapshot.documents.map { $0.documentID }
        
        withAnimation {
            self.rsvpedUids = userIds
        }
    }
    
    @MainActor
    func fetchInvitedUsers(eventId: String) async throws {
        let invitedUsers = try await EventService.fetchInvitedUsers(forEventId: eventId)
        self.invitedUsers = invitedUsers
    }
    
    func deleteEvent() async throws {
        try await Firestore.firestore().collection("events").document(event.id).delete()
    }
    
    @MainActor
    func ditch() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let eventRef = Firestore.firestore().collection("events").document(event.id)
        
        var newUids = [String: Any]()
        newUids["invitesUids"] = FieldValue.arrayRemove([currentUid])
        
        try await eventRef.updateData(newUids)
        
        try? await eventRef
                .collection("rsvpedUsers")
                .document(currentUid)
                .delete()
        
        withAnimation {
            self.event.invitesUids.removeAll { $0 == currentUid }
            self.isRSVPd = false 
        }
    }
    
}
