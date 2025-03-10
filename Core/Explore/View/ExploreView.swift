//
//  ExploreView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct ExploreView: View {
    
    @State private var searchText = ""
    @StateObject var viewModel = ExploreViewModel()
     
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.users) { user in
                        NavigationLink(value: user) {
                            UserCell(user: user, isEvent: false, isRSVPd: false)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        }
                        .foregroundStyle(.black)
                    }
                }
                .searchable(text: $searchText, prompt: "Search...")
            }
            .navigationDestination(for: User.self) { user in
                GuestUserProfileView(user: user)
            }
            .navigationBarTitle("Explore")
        }
        
    }
}

#Preview {
    ExploreView()
}
