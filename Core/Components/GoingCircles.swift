//
//  GoingCircles.swift
//  Moves
//
//  Created by Adam Sherif on 2/25/25.
//

import SwiftUI
import Kingfisher

struct GoingCircles: View {
    let event: Event
    
    @EnvironmentObject var viewModel: MapAnnotationsViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        NavigationLink {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.invitedUsers) { user in
                            UserCell(user: user, isEvent: false, isRSVPd: true)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Invited:")
            .navigationBarTitleDisplayMode(.inline)
            
        } label: {
            HStack(spacing: 10) {
                ForEach(0 ..< min(viewModel.invitedUsers.count, 5), id: \.self) { index in
                    if viewModel.invitedUsers[index].profileImageUrl == "" {
                        
                        ZStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color(.systemGray3))
                            Image(systemName: "person.fill")
                                .foregroundStyle(.white)
                        }
                        .offset(x: CGFloat(-15 * index))
                    } else {
                        KFImage(URL(string: viewModel.invitedUsers[index].profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 20, height: 20)
                            .offset(x: CGFloat(-15 * index))
                    }
                }
                
                if viewModel.invitedUsers.count > 5 {
                    Text("+ \(viewModel.invitedUsers.count - 5)")
                        .font(.footnote)
                        .offset(x: CGFloat(-15 * 5))
                }
            }
        }
        .onAppear {
            Task { try await viewModel.fetchInvitedUsers(eventId: event.id) }
            print("DEUBG: GoingCircles onAppear: \(viewModel.invitedUsers)")
        }
    }
}

#Preview {
    GoingCircles(event: DeveloperPreview.event)
}

