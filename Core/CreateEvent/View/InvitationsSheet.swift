//
//  InvitationsSheet.swift
//  Moves
//
//  Created by Adam Sherif on 3/13/25.
//
import SwiftUI

struct InvitationsSheet: View {
    @EnvironmentObject var viewModel: EditEventViewModel
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                
                Text("Invite")
                    .font(.headline)
                    .padding(.leading, 28)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .foregroundStyle(.white)
                        .font(.caption)
                        .frame(width: 50, height: 25)
                        .background(.purple)
                        .clipShape(Rectangle()).cornerRadius(10)
                }
            }
            .padding()
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.friends) { friend in
                        let isSelected = viewModel.invitedUsers.contains(where: { $0.id == friend.id })
                        SelectableUserCell(user: friend, isSelected: isSelected) {
                            if isSelected {
                                withAnimation {
                                    viewModel.invitedUsers.removeAll { $0.id == friend.id }
                                }
                            } else if !viewModel.invitedUsers.contains(where: { $0.id == friend.id }) {
                                withAnimation {
                                    viewModel.invitedUsers.append(friend)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}
