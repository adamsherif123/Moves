//
//  ImageAndFullnameView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct ImageAndFullnameView: View {
    
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            SignUpFlowView(textComponent: $viewModel.fullname, isPassword: false, isImageShowing: true, title: "Finish Off", subtitle: "Adding an image is optional but will help your friends know who you are.", textFieldPlaceholder: "Fullname", month: $viewModel.month, day: $viewModel.day, year: $viewModel.year, isMale: $viewModel.isMale, isFemale: $viewModel.isFemale, isOther: $viewModel.isOther)
            
            NavigationLink {
                CompleteSignUpView()
            } label: {
                Text("Next")
                    .modifier(LoginButtonModifier())
            }
            .padding(.vertical, 24)
            
            Spacer()
        }
    }
}

#Preview {
    ImageAndFullnameView()
}
