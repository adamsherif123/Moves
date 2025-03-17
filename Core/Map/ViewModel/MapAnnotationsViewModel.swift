//
//  MapAnnotationsViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 2/24/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class MapAnnotationsViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    @Published var users: [User] = []
    static let shared = MapAnnotationsViewModel()
    
    @MainActor
    func fetchUserEvents() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        self.events = try await EventService.fetchEvents(forUserId: currentUid)
    }
    
    @MainActor
    func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        var friends = try await UserService.fetchUserFriends(withUid: currentUid)
        let currentUser = try await UserService.fetchUser(withUid: currentUid)
        friends.append(currentUser)
        
        self.users = friends
    }
}







