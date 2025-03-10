//
//  WelcomeView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct WelcomeView: View {
    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("Moves")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.purple)
                    
                    
                    Text("When moments meet, friends follow.")
                        .font(.subheadline)
                }
                
                
                Spacer()
                
                VStack(spacing: 24) {
                    Text("Get started")
                        .font(.headline)
                    
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Next")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                            .frame(width: 352, height: 44)
                            .background(.purple)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
