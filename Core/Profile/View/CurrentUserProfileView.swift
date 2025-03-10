//
//  CurrentUserProfileView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct CurrentUserProfileView: View {
    
    let user: User
    @State private var editProfile = false
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ProfileHeader(user: user, viewModel: viewModel, isGuest: false)
                ProfileCalendarScrollView(user: user)
            }
            .padding(.vertical)
            .navigationBarTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Button(action: {
                            editProfile.toggle()
                        }) {
                            Label("Edit Profile", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            AuthService.shared.signOut()
                        }) {
                            Label("Log Out", systemImage: "arrow.backward")
                        }
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.black)
                    }
                }
            }
            .fullScreenCover(isPresented: $editProfile) {
                EditProfileView(user: user)
            }
        }
    }
}

#Preview {
    CurrentUserProfileView(user: DeveloperPreview.user)
}
