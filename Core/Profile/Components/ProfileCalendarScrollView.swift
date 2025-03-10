//
//  ProfileCalendarScrollView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct ProfileCalendarScrollView: View {
    @StateObject var viewModel = ProfileViewModel()
    let user: User
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.events) { event in
                    ProfileCalendarCellView(event: event)
                    
                }
            }
            .onAppear {
                Task { try await viewModel.fetchUserEvents(uid: user.id) }
                
                print("DEBUG: Events array is: \(viewModel.events)" )
            }
        }
    }
}

#Preview {
    ProfileCalendarScrollView(user: DeveloperPreview.user)
}
