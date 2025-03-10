//
//  AuthService.swift
//  Moves
//
//  Created by Adam Sherif on 3/1/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    init() {
        Task { try await loadUserData() }
    }

    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
        } catch {
            print("DEBUG: Failed to Log in user: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(
        withEmail email: String,
        username: String,
        password: String,
        profileImageUrl: String,
        fullname: String,
        dob: String,
        gender: String) async throws {
            
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            print("DEBUG: Did upload create user...")
            await uploadUserData(uid: result.user.uid,
                                 email: email,
                                 username: username,
                                 fullName: fullname,
                                 profileImageUrl: profileImageUrl,
                                 isCalendarPrivate: false,
                                 isMapPrivate: false,
                                 circlesCount: 0,
                                 friendsCount: 0,
                                 latitude: 0.0,
                                 longitude: 0.0,
                                 dob: dob,
                                 gender: gender)
            print("DEBUG: Did upload upload user data...")
            try await loadUserData()
        } catch {
            print("DEBUG: Failed to register user: \(error.localizedDescription)")
        }
    }
    
    private func uploadUserData(uid: String,
                                email: String,
                                username: String,
                                fullName: String,
                                profileImageUrl: String,
                                isCalendarPrivate: Bool,
                                isMapPrivate: Bool,
                                circlesCount: Int,
                                friendsCount: Int,
                                latitude: Double,
                                longitude: Double,
                                dob: String,
                                gender: String) async {
        let user = User(id: uid,
                        email: email,
                        username: username,
                        fullName: fullName,
                        profileImageUrl: profileImageUrl,
                        isCalendarPrivate: isCalendarPrivate,
                        isMapPrivate: isMapPrivate,
                        circlesCount: circlesCount,
                        friendsCount: friendsCount,
                        latitude: latitude,
                        longitude: longitude,
                        dob: dob,
                        gender: gender)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        
        try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
    
    @MainActor
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = userSession?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
        self.currentUser = try snapshot.data(as: User.self)
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
}
