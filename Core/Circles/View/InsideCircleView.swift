//
//  InsideCircleView.swift
//  Moves
//
//  Created by Adam Sherif on 3/24/25.
//

import SwiftUI

struct InsideCircleView: View {
    let circle: Circles
    @StateObject var viewModel: CircleChatViewModel
    
    init(circle: Circles) {
        self._viewModel = StateObject(wrappedValue: CircleChatViewModel(circle: circle))
        self.circle = circle
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        MessageView(message: message)
                    }
                }
            }
            
            CustomInputView(text: $viewModel.messageText) {
                Task { try await viewModel.sendMessage() }
            }
        }
        .navigationTitle("\(circle.name)")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.vertical)
        .toolbar(.hidden, for: .tabBar)
    }
}

