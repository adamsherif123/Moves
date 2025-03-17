//
//  MainTabView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct MainTabView: View {
    
    let user: User
    
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            MapView(user: user)
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        
                        Text("Home")
                    }
                }.tag(0)
            
            
            ExploreView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.2")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("Explore")
                    }
                }.tag(1)
            
            
            CirclesView()
                .tabItem {
                    VStack {
                        Image(systemName: "network")
                            .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                        Text("Circles")
                    }
                }.tag(2)
            
            
            CurrentUserProfileView(user: user)
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                            .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                        Text("Profile")
                    }
                }.tag(3)
        }
        .tint(.purple)
        
        
    }
}

#Preview {
    MainTabView(user: DeveloperPreview.user)
}
