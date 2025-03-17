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
    
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        NavigationLink {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(eventViewModel.invitedUsers) { user in
                            HStack {
                                UserCell(user: user, isEvent: false, isRSVPd: true)
                                
                                if eventViewModel.rsvpedUids.contains(user.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .imageScale(.medium)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Invited:")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task { try await eventViewModel.fetchRsvpedUids() }
            }
            
        } label: {
            HStack(spacing: 10) {
                ForEach(0 ..< min(eventViewModel.invitedUsers.count, 5), id: \.self) { index in
                    if eventViewModel.invitedUsers[index].profileImageUrl == "" {
                        
                        ZStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color(.systemGray3))
                            Image(systemName: "person.fill")
                                .foregroundStyle(.white)
                        }
                        .offset(x: CGFloat(-15 * index))
                    } else {
                        KFImage(URL(string: eventViewModel.invitedUsers[index].profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 20, height: 20)
                            .offset(x: CGFloat(-15 * index))
                    }
                }
                
                if eventViewModel.invitedUsers.count > 5 {
                    Text("+ \(eventViewModel.invitedUsers.count - 5)")
                        .font(.footnote)
                        .offset(x: CGFloat(-15 * 5))
                }
            }
        }
        .onAppear {
            print("DEUBG: GoingCircles onAppear: \(eventViewModel.invitedUsers)")
        }
    }
}

#Preview {
    GoingCircles(event: DeveloperPreview.event)
}

