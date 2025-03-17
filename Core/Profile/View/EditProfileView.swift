//
//  EditProfileView.swift
//  Moves
//
//  Created by Adam Sherif on 3/2/25.
//

import SwiftUI
import PhotosUI
import Kingfisher


struct EditProfileView: View {
    
    @StateObject var viewModel: EditProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
    }
    @MainActor
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                
                Spacer()
                
                Text("Edit Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    Task { try await viewModel.updateUserData() }
                } label: {
                    Text("Done")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            .padding()
            
            PhotosPicker(selection: $viewModel.selectedImage) {
                VStack {
                    if let image = viewModel.profileImage {
                        image
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.white)
                            .background(.gray)
                            .clipShape(Circle())
                    } else if viewModel.profileImageUrl != "" {
                        KFImage(URL(string: viewModel.profileImageUrl))
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.white)
                            .background(.gray)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "peson")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.white)
                            .background(.gray)
                            .clipShape(Circle())
                    }
                    
                    Text("Edit profile picture")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your username", text: $viewModel.username)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your fullname", text: $viewModel.fullname)
                    .modifier(TextFieldModifier())
            }
            .padding(.top)
            
            Spacer()
        }
    }
}

struct EditProfileRowView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 8)
                .frame(width: 100, alignment: .leading)
            
            VStack {
                TextField(placeholder, text: $text)
                
                Divider()
            }
            .font(.subheadline)
            .frame(height: 36)
        }
    }
}

#Preview {
    EditProfileView(user: DeveloperPreview.user)
}
