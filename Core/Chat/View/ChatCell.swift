//
//  ChatRowView.swift
//  Moves
//
//  Created by Adam Sherif on 3/22/25.
//

import SwiftUI

struct ChatCell: View {
    let event: Event
    var body: some View {
        VStack {
            HStack {
                Text("\(event.emoji)")
                    .font(.system(size: 29))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(event.title)")
                        .font(.system(size: 14, weight: .semibold))
                    
                    
                    Text("\(event.lastMessage ?? "This is a test message for now")")
                        .font(.system(size: 15))
                }
                Spacer()
            }
            .padding(.horizontal)

            
            Divider()
        }
        .padding(.top)
    }
}
