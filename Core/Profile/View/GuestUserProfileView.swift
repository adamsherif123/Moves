//
//  GuestUserProfileView.swift
//  Moves
//
//  Created by Adam Sherif on 12/28/24.
//

import SwiftUI

struct GuestUserProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    let user: User
    var body: some View {
        VStack {
            
            ProfileHeader(user: user, viewModel: viewModel, isGuest: true)
            
            ProfileCalendarScrollView(user: user)
        }
        .padding(.vertical)
    }
}

#Preview {
    GuestUserProfileView(user: DeveloperPreview.user)
}
