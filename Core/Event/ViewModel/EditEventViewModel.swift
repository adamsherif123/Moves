//
//  EditEventViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/12/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class EditEventViewModel: ObservableObject {
    @Published var event: Event
    @Published var emoji: String? = ""
    @Published var title: String? = ""
    @Published var description: String?
    @Published var locationTitle: String?
    @Published var invitedUsers: [User] = []
    @Published var startDate = Date()
    @Published var startTime = Date()
    @Published var friends = [User]()
    
    init(event: Event) {
        self.event = event
        self.emoji = event.emoji
        self.title = event.title
        self.description = event.description
        self.locationTitle = event.locationTitle
        self.startDate = event.time?.dateValue() ?? Date()
        self.startTime = event.time?.dateValue() ?? Date()
        
        Task {
            try await fetchFriends()
            try await fetchInvitedUsers()
            
        }
        
    }
    
    @MainActor
    func fetchInvitedUsers() async throws {
        let fetchedUsers = try await EventService.fetchInvitedUsers(forEventId: event.id)
        self.invitedUsers = fetchedUsers
        
    }
    
    @MainActor
    func fetchFriends() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let userFriends = try await UserService.fetchUserFriends(withUid: currentUid)
        self.friends = userFriends
    }
    
    func updateUserData() async throws {
        var data = [String: Any]()
        
        if event.emoji != emoji {
            data["emoji"] = emoji
        }
        
        if event.title != title {
            data["title"] = title
        }
        
        if event.description != description {
            data["description"] = description
        }
        
        if event.locationTitle != locationTitle {
            data["locationTitle"] = locationTitle
            data["latitude"] = LocationSearchViewModel.shared.selectedLatitude
            data["longitude"] = LocationSearchViewModel.shared.selectedLongitude
        }
        
        
        let newInvitedIds = Set(invitedUsers.map { $0.id })
        let oldInvitedIds = Set(event.invitesUids)
        
        if newInvitedIds != oldInvitedIds {
            data["invitesUids"] = Array(newInvitedIds)
        }
        
        if !data.isEmpty {
            try await Firestore.firestore().collection("events")
                .document(event.id).updateData(data)
        }
    }
}
