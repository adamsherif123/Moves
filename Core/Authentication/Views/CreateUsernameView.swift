//
//  CreateUsernameView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct CreateUsernameView: View {
    
    @EnvironmentObject var viewModel: RegistrationViewModel

    
    var body: some View {
        VStack(spacing: 12) {
            SignUpFlowView(textComponent: $viewModel.username, isPassword: false, isImageShowing: false, title: "Create username", subtitle: "Pick a username for your account. You can always change it later.", textFieldPlaceholder: "Username")
            
            NavigationLink {
                CreatePasswordView()
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
    CreateUsernameView()
}
