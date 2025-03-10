//
//  CompleteSignUpView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct CompleteSignUpView: View {
    
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Welcome to Moves, \(viewModel.username)")
                .font(.title2)
                .fontWeight(.semibold)
                
            Text("Click below to complete your registration and start using Moves.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Complete Sign Up")
                    .modifier(LoginButtonModifier())
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    CompleteSignUpView()
}
