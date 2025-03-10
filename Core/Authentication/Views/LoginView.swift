//
//  LoginView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Hello.")
                
                Text("Welcome to Moves!")
                    .foregroundStyle(.purple)
            }
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(TextFieldModifier())
            }
            .padding(.vertical)
            
            Button {
                
            } label: {
                Text("Forgot Password?")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.trailing, 28)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Button {
                Task { try await viewModel.signIn() }
            } label: {
                Text("Login")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)
                    .frame(width: 360, height: 44)
                    .background(.purple)
                    .cornerRadius(10)
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            NavigationLink {
                AddEmailView()
            } label: {
                HStack(spacing: 3 ) {
                    Text("Don't have an account?")
                    
                    Text("Sign Up").bold()
                }
                .font(.footnote)
                .foregroundStyle(.blue)
            }
            .padding(.vertical, 16)
        }
        
    }
}

#Preview {
    LoginView()
}
