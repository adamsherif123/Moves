//
//  UserProfileImage.swift
//  Moves
//
//  Created by Adam Sherif on 3/25/25.
//

import SwiftUI
import Kingfisher

struct UserProfileImage: View {
    
    let user: User
    let width: CGFloat
    let height: CGFloat
    let imageScale: Image.Scale
    
    var body: some View {
        if user.profileImageUrl == "" {
            ZStack {
                Circle()
                    .foregroundStyle(Color(.systemGray3))
                    .frame(width: width, height: height)
                
                Image(systemName: "person")
                    .foregroundStyle(.white)
                    .imageScale(imageScale)
            }
        } else {
            KFImage(URL(string: user.profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(Circle())
        }
    }
}
