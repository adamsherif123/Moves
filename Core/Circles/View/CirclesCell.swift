//
//  CirclesCell.swift
//  Moves
//
//  Created by Adam Sherif on 3/24/25.
//

import SwiftUI
import Kingfisher

struct CirclesCell: View {
    let circle: Circles
    var body: some View {
        VStack {
            HStack {
                if let imageUrl = circle.imageUrl {
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    ZStack {
                        Circle()
                            .frame(width: 60)
                            .foregroundStyle(Color(.systemGray3))
                        
                        Image(systemName: "person.3")
                            .imageScale(.large)
                            .foregroundStyle(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(circle.name)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    Group {
//                        Text("\(circle.user?.fullName ?? "") • ")
//                            .bold() +
                        Text("\(circle.lastMessage)")
                            
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    
                    let date = circle.lastMessageTimestamp.dateValue()
                    Text(timeAgoSince(date))
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                        .bold()
                    
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

