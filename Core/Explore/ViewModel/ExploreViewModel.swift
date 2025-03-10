//
//  ExploreViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/1/25.
//

import Foundation

class ExploreViewModel: ObservableObject {
    
    @Published var users =  [User]()
    
    init() {
        Task { try await fetchAllUsers() }
    }
    
    @MainActor
    func fetchAllUsers() async throws {
        self.users = try await UserService.fetchAllUsers()
    }
}
