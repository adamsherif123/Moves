//
//  AddCircleNameView.swift
//  Moves
//
//  Created by Adam Sherif on 3/24/25.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct AddCircleNameView: View {
    
    @EnvironmentObject var viewModel: CirclesViewModel
    let dismissSheet: () -> Void
    private let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        
        ScrollView {
            VStack {
                Spacer()
                HStack {
                    PhotosPicker(selection: $viewModel.selectedImage) {
                        if let image = viewModel.cirleImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                        } else {
                            ZStack {
                                Circle()
                                    .frame(width: 45)
                                    .foregroundStyle(Color(.systemGray6))
                                
                                Image(systemName: "camera")
                            }
                        }
                    }
                    
                    TextField("Group Name", text: $viewModel.circleName)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                }
                .padding()
                
                Text("Members: \(viewModel.selectedFriends.count) OF \(viewModel.friends.count)")
                    .bold()
                    .foregroundStyle(.gray)
                    .font(.caption)
                    .padding([.top, .horizontal])
                    .padding(.bottom, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.selectedFriends) { friend in
                        VStack {
                            if friend.profileImageUrl != "" {
                                ZStack(alignment: .topTrailing) {
                                    KFImage(URL(string: friend.profileImageUrl))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    
                                    Button {
                                        viewModel.selectedFriends.removeAll {
                                            $0.id == friend.id
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 17)
                                                .foregroundStyle(Color(.systemGray3))
                                            
                                            Image(systemName: "multiply")
                                                .resizable()
                                                .frame(width: 7, height: 7)
                                                .bold()
                                                .foregroundStyle(.white)
                                        }
                                        .padding(.horizontal, -6)
                                        .padding(.vertical, -4)
                                    }
                                }
                            } else {
                                ZStack(alignment: .topTrailing) {
                                    ZStack {
                                        Circle()
                                            .frame(width: 40)
                                            .foregroundStyle(Color(.systemGray5))
                                        
                                        Image(systemName: "person")
                                            .imageScale(.medium)
                                            .foregroundStyle(.white)
                                        
                                    }
                                    
                                    Button {
                                        viewModel.selectedFriends.removeAll {
                                            $0.id == friend.id
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 17)
                                                .foregroundStyle(Color(.systemGray3))
                                            
                                            Image(systemName: "multiply")
                                                .resizable()
                                                .frame(width: 7, height: 7)
                                                .bold()
                                                .foregroundStyle(.white)
                                        }
                                        .padding(.horizontal, -6)
                                        .padding(.vertical, -4)
                                    }
                                }
                            }
                            
                            Text(extractFirstName(from: friend.fullName))
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                Spacer()
                Spacer()
            }
            .padding(.top)
            .navigationTitle("New Circle")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { try await viewModel.createCircle() }
                        dismissSheet()
                    } label: {
                        Text("Create")
                            .bold()
                            .opacity(viewModel.circleName == "" ? 0.5 : 1)
                    }
                    .disabled(viewModel.circleName == "")
                }
            }
        }
    }
    
    func extractFirstName(from fullName: String?) -> String {
        guard let fullName = fullName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !fullName.isEmpty else {
            return ""
        }
        let nameParts = fullName.components(separatedBy: " ")
        
        return nameParts.first ?? ""
    }
}

