//
//  ChatScrollView.swift
//  Moves
//
//  Created by Adam Sherif on 3/22/25.
//

import SwiftUI

struct ChatScrollView: View {
    
    @State private var showSheet = false
    @State private var showChatView = false
    @EnvironmentObject var mapAnnotationsViewModel: MapAnnotationsViewModel
    
    var body: some View {
            ScrollView {
                VStack {
                    ForEach(mapAnnotationsViewModel.events) { event in
                        NavigationLink {
                            InsideChatView(event: event)
                        } label: {
                            ChatCell(event: event)
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("Chats")
    }
}
