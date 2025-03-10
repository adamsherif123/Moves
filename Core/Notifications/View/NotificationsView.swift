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
    @StateObject var viewModel = NotificationsViewModel()
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
                            if user.profileImageUrl == "" {
                                ZStack {
                                    Circle()
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "person")
                                        .foregroundStyle(.white)
                                        .imageScale(.small)
                                    
                                }
                            } else {
                                KFImage(URL(string: user.profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 40, height: 40)
                            }
                            
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
                
                ForEach(0...20, id: \.self) { item in
                    HStack {
                        NavigationLink {
                            GuestUserProfileView(user: user)
                        } label: {
                            HStack {
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 40, height: 40)
                                
                                Group {
                                    Text("adamsherif_").fontWeight(.semibold) +
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
                        
                        NavigationLink {
                            
                        } label: {
                            Text("🍴")
                                .font(.title)
                        }
                    }
                    .padding(.horizontal)
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

