//
//  InsideChatView.swift
//  Moves
//
//  Created by Adam Sherif on 3/22/25.
//

import SwiftUI

struct InsideChatView: View {
    
    @StateObject var viewModel: ChatViewModel
    let event: Event
    
    init(event: Event) {
        self._viewModel = StateObject(wrappedValue: ChatViewModel(event: event))
        self.event = event
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
        .navigationTitle("\(event.title)")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.vertical)
    }
}


