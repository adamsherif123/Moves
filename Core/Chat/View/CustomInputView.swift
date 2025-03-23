//
//  CustomInputView.swift
//  Moves
//
//  Created by Adam Sherif on 3/22/25.

import SwiftUI

struct CustomInputView: View {
    @Binding var text: String
    var action: () -> Void
    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(Color(.separator))
                .frame(width: UIScreen.main.bounds.width, height: 0.75)
            
            HStack {
                TextField("Message...", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
                    .frame(minHeight: 30)
                
                Button {
                    action()
                } label: {
                    Text("Send")
                        .bold()
                        .foregroundStyle(.black)
                }
            }
            .padding(.bottom, 8)
            .padding(.horizontal)
        }
    }
}

#Preview {
    CustomInputView(text: .constant("Message"), action: {})
}

