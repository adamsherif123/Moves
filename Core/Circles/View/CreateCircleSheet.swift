//
//  CreateCircleSheet.swift
//  Moves
//
//  Created by Adam Sherif on 3/24/25.
//

import Kingfisher
import PhotosUI
import SwiftUI

struct CreateCircleSheet: View {
    
    @StateObject var viewModel = CirclesViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.black)
                }
                Spacer()
                Text("Add Members:")
                    .foregroundStyle(.black)
                
                Spacer()
                
                NavigationLink {
                    AddCircleNameView(dismissSheet: {
                        dismiss()
                    })
                        .environmentObject(viewModel)
                } label: {
                    Text("Next")
                        .foregroundStyle(.black)
                        .opacity(viewModel.selectedFriends.isEmpty ? 0.5 : 1.0)
                }
                .disabled(viewModel.selectedFriends.isEmpty)
            }
            .padding()
            
            ScrollView {
                VStack {
                    ForEach(viewModel.friends) { friend in
                        let isSelected = viewModel.selectedFriends.contains(
                            where: { $0.id == friend.id })
                        
                        SelectableUserCell(user: friend, isSelected: isSelected)
                        {
                            if isSelected {
                                withAnimation {
                                    viewModel.selectedFriends.removeAll {
                                        $0.id == friend.id
                                    }
                                }
                            } else {
                                withAnimation {
                                    viewModel.selectedFriends.append(friend)
                                }
                            }
                        }
                    }
                }
                .padding()
                .onAppear {
                    Task { try await viewModel.fetchFriends() }
                    print(
                        "Selected group members: \(viewModel.selectedFriends)")
                }
                .onChange(of: viewModel.selectedFriends) { oldValue, newValue in
                    print("Selected group members new value: \(newValue)")
                    print("Selected group members old value: \(oldValue)")
                }
            }
        }
    }
}

#Preview {
    CreateCircleSheet()
}
