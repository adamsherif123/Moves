//
//  UserCell.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI
import Kingfisher

struct UserCell: View {
    let user: User
    let isEvent: Bool
    let isRSVPd: Bool
    
    var body: some View {
        HStack {
            if user.profileImageUrl == "" {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color(.systemGray4))
                    
                    Image(systemName: "person")
                        .foregroundColor(.white)
                }
                
            } else {
                KFImage(URL(string: user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.footnote)
                    
                
                HStack(spacing: 2) {
                    Text(user.username)
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    if isEvent {
                        Text(" 3m")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
            
            Spacer()
        }
    }
}
