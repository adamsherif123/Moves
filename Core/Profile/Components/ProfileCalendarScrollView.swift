//
//  ProfileCalendarScrollView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct ProfileCalendarScrollView: View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.events) { event in
                    ProfileCalendarCellView(event: event)
                    
                }
            }
            .onAppear {
//                Task { viewModel.fetchUserEvents(uid: viewModel.user.id) }
                
                print("DEBUG: Events array is: \(viewModel.events)" )
            }
        }
    }
}

#Preview {
    ProfileCalendarScrollView()
}
