//
//  LoginViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/1/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
