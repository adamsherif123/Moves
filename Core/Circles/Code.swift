//
//  Code.swift
//  Moves
//
//  Created by Adam Sherif on 3/11/25.
//

import SwiftUI

struct Code: View {
    
    @State private var codeEntered = ""
    @StateObject var viewModel = CodeViewModel()
    
    var body: some View {
        
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 17))
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                }
                .padding()
                
                Spacer()
                
                Button {
                    Task { try await viewModel.createCircle() }
                } label: {
                    Text("Create Circle")
                }
                Button {
                    Task { try await viewModel.generateCode() }
                } label: {
                    Text("Genarate code")
                }
                
                if !viewModel.generatedCode.isEmpty {
                    Text("Generated code: \(viewModel.generatedCode)")
                        .font(.headline)
                }
                
                TextField("Enter code", text: $viewModel.code)
                    .padding(8)
                    .modifier(Modifierr())
                
                
                Button {
                    viewModel.checkCode()
                } label: {
                    Text("Submit")
                }
                
                Text("\(viewModel.statusMessage)")
                
                
            }
        }
    }
}

#Preview {
    Code()
}
