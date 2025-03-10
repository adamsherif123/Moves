//
//  ProfileHeader.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI
import Kingfisher

struct ProfileHeader: View {
    
    let user: User
    @ObservedObject var viewModel: ProfileViewModel
    
    let isGuest: Bool
    
    @Environment(\.dismiss) var dismiss
    
    @State private var unfriendSheet = false

    var body: some View {
        HStack {
            if user.profileImageUrl == "" {
                ZStack {
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        
                }
                
            } else {
                
                KFImage(URL(string: user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
            }
            
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.headline)
                
                Text("@\(user.username)")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                
                HStack {
                    Text("\(user.circlesCount)").bold() +
                    Text(" Circles")
                    
                    Text("\(viewModel.friendsCount)").bold() +
                    Text(viewModel.friendsCount == 1 ? " Friend" : " Friends")
                }
                .font(.subheadline)
                
                if !user.isCurrentUser, let request = viewModel.isFriendFreindRequestSent,
                    let friends = viewModel.isFriend,
                    let theySentMe = viewModel.didUserSendMeRequest {
                    Button {
                        if friends == true {
                            unfriendSheet.toggle()
                        } else if request == true {
                            Task { try await viewModel.removeFriendRequest(to: user) }
                        } else if theySentMe == true {
                            Task { try await viewModel.acceptFriendRequest(from: user) }
                        } else {
                            Task { try await viewModel.sendFriendRequest(to: user) }
                        }
                    } label: {
                        Text(friends ? "Friends" : request ? "Pending" : theySentMe ? "Accept + " : "Add Friend +")
                            .foregroundStyle(friends ? .black : request ? .black : .white)
                            .font(.caption)
                            .frame(width: 120, height: 25)
                            .background(friends ? Color(.systemGray5) : request ? Color(.systemGray5) : .purple)
                            .clipShape(Rectangle()).cornerRadius(10)
                    }
                }

            }
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            viewModel.listenToFriendsCount(for: user)
            
            if isGuest {
                Task { try await viewModel.checkIfFriendsOrIfRequested(for: user) }
            }
        }
        .onDisappear {
            viewModel.removeFriendsCountListener()
        }
        .sheet(isPresented: $unfriendSheet) {
            VStack {
                if user.profileImageUrl != "" {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    
                } else {
                    ZStack {
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundStyle(Color(.systemGray3))
                        
                        Image(systemName: "person")
                            .imageScale(.medium)
                            .foregroundStyle(.white)

                    }
                }
                
                Text("Are you sure you want to unfriend \(user.username)?")
                    .padding(.top)
                
                Button {
                    Task { try await viewModel.unfriend(with: user) }
                    unfriendSheet.toggle()
                    
                } label: {
                    Text("Confirm, I am cutting them off")
                        .font(.subheadline).bold()
                }
                .padding()
                
                Button {
                    unfriendSheet.toggle()
                } label: {
                    Text("Cancel")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }
            }
            .presentationDetents([.fraction(0.3)])
        }
    }
}
