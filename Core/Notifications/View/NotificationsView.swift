//
//  NotificationsView.swift
//  Moves
//
//  Created by Adam Sherif on 3/5/25.
//

import SwiftUI
import Kingfisher

enum NotificationsType: Int, CaseIterable {
    case invites
    case friendRequests
    case suggestedFriends
    
    var title: String {
        
        switch self {
        case.invites: return "Invites"
        case.friendRequests: return "Friend Requests"
        case.suggestedFriends: return "Suggested Friends"
        }
    }
    
    var frameSize: CGSize {
        switch self {
        case.invites: return CGSize(width: 70, height: 32)
        case.friendRequests: return CGSize(width: 120, height: 32)
        case.suggestedFriends: return CGSize(width: 130, height: 32)
        }
    }
}

struct NotificationsView: View {
    
    @State private var selectedFilter: NotificationsType = .invites
    @EnvironmentObject var viewModel: NotificationsViewModel
    @State private var showInvite = false
    @EnvironmentObject var mapViewModel: MapAnnotationsViewModel
    let user: User
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                HStack {
                    ForEach(NotificationsType.allCases, id: \.self) { item in
                        Button {
                            withAnimation {
                                self.selectedFilter = item
                            }
                        } label: {
                            Text(item.title)
                                .fontWeight(.semibold)
                                .font(.caption)
                                .foregroundColor(.black)
                                .frame(width: item.frameSize.width, height: item.frameSize.height)
                                .background(RoundedRectangle(cornerRadius: 10).fill(selectedFilter == item ? Color(.purple.opacity(0.4)): Color(.systemGray5)))
                        }
                    }
                }
                .padding(.vertical)
                
                
                TabView(selection: $selectedFilter) {
                    eventInviteView.tag(NotificationsType.invites)
                    friendRequestView.tag(NotificationsType.friendRequests)
                    suggestedFriendsView.tag(NotificationsType.suggestedFriends)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
        }
        .accentColor(.black)
        .onAppear {
            viewModel.loadFriendRequests(for: user.id)
            Task { try await viewModel.loadInvites() }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

extension NotificationsView {
    
    var friendRequestView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.friendRequests) { request in
                    if let user = request.user {
                        HStack {
                            UserProfileImage(user: user, width: 40, height: 40, imageScale: .small)
                            
                            VStack(alignment: .leading) {
                                
                                Text(user.username)
                                    .fontWeight(.semibold)
                                    .font(.subheadline)
                                
                                
                                HStack(spacing: 2) {
                                    Text("sent you a friend request")
                                    Text(" 2d").foregroundStyle(.gray)
                                }
                                .font(.footnote)
                            }
                            
                            Spacer()
                            
                            Button {
                                Task { try await viewModel.aceeptFriendRequest(request) }
                            } label: {
                                Text("Accept")
                                    .foregroundStyle(.white)
                                    .font(.caption)
                                    .frame(width: 60, height: 25)
                                    .background(.purple)
                                    .clipShape(Rectangle()).cornerRadius(10)
                            }
                            
                            Button {
                                Task { try await viewModel.deleteFriendRequest(request) }
                            } label: {
                                Text("Delete")
                                    .foregroundStyle(.black)
                                    .font(.caption)
                                    .frame(width: 60, height: 25)
                                    .background(Color(.systemGray5))
                                    .clipShape(Rectangle()).cornerRadius(10)
                            }
                            
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    var eventInviteView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.invitedEvents) { event in
                    if let user = event.user {
                        HStack {
                            NavigationLink {
                                GuestUserProfileView(user: user)
                            } label: {
                                HStack {
                                    if user.profileImageUrl != "" {
                                        KFImage(URL(string: user.profileImageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 40, height: 40)
                                    } else {
                                        ZStack {
                                            Circle()
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: "person")
                                                .foregroundStyle(.white)
                                                .imageScale(.small)
                                            
                                        }
                                    }
                                    
                                    Group {
                                        Text("\(user.username)").fontWeight(.semibold) +
                                        Text(" invited you to an event!") +
                                        Text(" 2d").foregroundStyle(.gray)
                                    }
                                    .frame(width: 200)
                                    .foregroundStyle(.black)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                showInvite.toggle()
                            } label: {
                                Text("\(event.emoji)")
                                    .font(.title)
                            }
                            .sheet(isPresented: $showInvite) {
                                EventView(user: user, event: event)
                                    .presentationDetents([.fraction(0.5)])
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    var suggestedFriendsView: some View {
        ScrollView {
            LazyVStack {
                Text("Hello World!")
            }
        }
    }
}

