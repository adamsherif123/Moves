//
//  CirclesView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct CirclesView: View {
    
    @State private var showCreateCircleSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Circles")
                        .bold()
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Button {
                        showCreateCircleSheet.toggle()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            
                            Text("Create")
                        }
                        .foregroundStyle(.purple)
                    }
                    .sheet(isPresented: $showCreateCircleSheet) {
                        CreateCircleSheet()
                    }
                }
                .padding(.horizontal)
                
                ForEach(0...10, id: \.self) { _ in
//                    ChatCell(event: )
                    Text("Circles")
                    
                }
            }
        }
    }
}

#Preview {
    CirclesView()
}
