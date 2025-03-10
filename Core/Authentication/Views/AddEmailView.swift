//
//  AddEmailView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct AddEmailView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            SignUpFlowView(textComponent: $viewModel.email, isPassword: false, isImageShowing: false, title: "Add your email", subtitle: "You'll use this email to log in to your account", textFieldPlaceholder: "Enter your email")
            
            NavigationLink {
                CreateUsernameView()
            } label: {
                Text("Next")
                    .modifier(LoginButtonModifier())
            }
            .padding(.vertical)
            
            Spacer()
        }
    }
}

#Preview {
    AddEmailView()
}
