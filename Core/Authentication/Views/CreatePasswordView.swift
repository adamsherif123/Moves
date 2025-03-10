//
//  CreatePasswordView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct CreatePasswordView: View {
    
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            SignUpFlowView(textComponent: $viewModel.password, isPassword: true, isImageShowing: false, title: "Create a password", subtitle: "Your password must be at least 6 characters long", textFieldPlaceholder: "Password")
            
            NavigationLink {
                ImageAndFullnameView()
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
    CreatePasswordView()
}
