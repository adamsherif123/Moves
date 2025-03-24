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
                    
                    Group {
                        Text("\(event.user?.fullName ?? "") • ")
                            .bold() +
                        Text("\(event.lastMessage ?? "This is a test message for now wjnef wekjhrjewr werjhk")")
                            
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    
                    if let timestamp = event.lastMessageTimestamp {
                        let date = timestamp.dateValue()
                        Text(timeAgoSince(date))
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                            .bold()
                    } else {
                        Text("N/A")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                            .bold()
                    }
                        
                }
                
                Spacer()
            }
            .padding(.horizontal)

            
            Divider()
        }
        .padding(.top, 8)
    }
    
    func timeAgoSince(_ date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour

        if seconds < minute {
            return "now"
        } else if seconds < hour {
            return "\(seconds / minute)m ago"
        } else if seconds < day {
            return "\(seconds / hour)h ago"
        } else {
            return "\(seconds / day)d ago"
        }
    }

}
