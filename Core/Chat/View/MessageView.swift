//
//  MessageView.swift
//  Moves
//
//  Created by Adam Sherif on 3/22/25.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct MessageView: View {
    let message: Message
    
    var currentUid: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    var isFromCurrentUser: Bool {
        return message.fromId == currentUid
    }
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
                Text(message.messageText)
                    .padding(12)
                    .background(Color(.blue))
                    .font(.system(size: 15))
                    .clipShape(ChatBubble(isFromCurrentUser: true))
                    .foregroundStyle(.white)
                    .padding(.leading, 100)
                    .padding(.horizontal)
                
            } else {
                HStack(alignment: .bottom) {
                    if let imageUrl = message.user?.profileImageUrl {
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                    } else {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color(.systemGray3))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "person")
                                .foregroundStyle(.white)
                                .imageScale(.medium)
                        }
                    }
                    
                    Text(message.messageText)
                        .padding(12)
                        .background(Color(.systemGray5))
                        .font(.system(size: 15))
                        .clipShape(ChatBubble(isFromCurrentUser: false))
                        .foregroundStyle(.black)
                }
                .padding(.horizontal)
                .padding(.trailing, 80)
                
                Spacer()
                
            }
        }
    }
}
