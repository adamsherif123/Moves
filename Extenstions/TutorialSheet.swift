//
//  TutorialSheet.swift
//  Moves
//
//  Created by Adam Sherif on 3/3/25.
//

import SwiftUI

struct TutorialSheet: View {
    let images = ["tutorial1", "tutorial2", "tutorial3", "tutorial4", "tutorial5", "tutorial6"]
    @State private var currentIndex = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Welcome to moves, here is how it works...")
                .multilineTextAlignment(.center)
                .font(.title2)
                .bold()
                .padding(.top)
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.clear
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.clear
            }
            
            Button {
                if currentIndex < images.count - 1 {
                    currentIndex += 1
                } else {
                    dismiss()
                }
                
                
            } label: {
                Text("Next")
                    .modifier(LoginButtonModifier())
            }
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    TutorialSheet()
}

