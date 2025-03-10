//
//  ProfileCalendarView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI
import Firebase

struct ProfileCalendarCellView: View {
    
    let event: Event
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if let eventTime = event.time {
                Text(formattedEventTime(from: eventTime, isHeader: true))
                    .font(.headline)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    if let eventTime = event.time {
                        Text(formattedEventTime(from: eventTime, isHeader: false))
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    
                    if let description = event.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .purple.opacity(0.7), radius: 4)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    func formattedEventTime(from timestamp: Timestamp, isHeader: Bool) -> String {
        let date = timestamp.dateValue()
        let formatter = DateFormatter()
        if isHeader {
            formatter.dateFormat = "MMM d, yyyy"
        } else {
            formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        }
        return formatter.string(from: date)
    }
}

#Preview {
    ProfileCalendarCellView(event: DeveloperPreview.event)
}
