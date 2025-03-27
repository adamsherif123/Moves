//
//  UserCell.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI
import Kingfisher

struct SelectableUserCell: View {
    let user: User
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            UserProfileImage(user: user, width: 40, height: 40, imageScale: .medium)
            
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.footnote)
                
                
                HStack(spacing: 2) {
                    Text(user.username)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isSelected ? .purple.opacity(0.2) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            onSelect()
        }
    }
}

