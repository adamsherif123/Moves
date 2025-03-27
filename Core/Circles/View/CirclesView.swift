//
//  CirclesView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct CirclesView: View {
    
    @State private var showCreateCircleSheet = false
    @StateObject var viewModel = CirclesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Circles")
                        .bold()
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Button {
                        showCreateCircleSheet.toggle()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            
                            Text("Create")
                        }
                        .foregroundStyle(.purple)
                    }
                    .sheet(isPresented: $showCreateCircleSheet, onDismiss: { Task { try await viewModel.fetchUserCircles() } }) {
                        CreateCircleSheet()
                            .environmentObject(viewModel)
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.userCircles) { circle in
                            NavigationLink {
                                InsideCircleView(circle: circle)
                            } label: {
                                CirclesCell(circle: circle)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await viewModel.fetchUserCircles()
                try await viewModel.fetchFriends()
            }
        }
    }
}

#Preview {
    CirclesView()
}
