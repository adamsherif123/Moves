//
//  GuestUserProfileView.swift
//  Moves
//
//  Created by Adam Sherif on 12/28/24.
//

import SwiftUI

struct GuestUserProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    var body: some View {
        VStack {
            
            ProfileHeader(user: viewModel.user, viewModel: viewModel, isGuest: true)
            
            ProfileCalendarScrollView()
                .environmentObject(viewModel)
        }
        .padding(.vertical)
    }
}

#Preview {
    GuestUserProfileView(user: DeveloperPreview.user)
}
