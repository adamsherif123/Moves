//
//  EditEventView.swift
//  Moves
//
//  Created by Adam Sherif on 3/11/25.
//

import SwiftUI

struct EditEventView: View {
    @StateObject var viewModel: EditEventViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showLocationView = false
    @State private var showInvitations = false
    
    init(event: Event) {
        self._viewModel = StateObject(wrappedValue: EditEventViewModel(event: event))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "multiply")
                        .foregroundStyle(.black)
                        .imageScale(.large)
                }
                
                Spacer()
                
                Text("Edit Event")
                    .font(.headline)
                    .padding(.leading, 20)
                
                Spacer()
                
                Button {
                    Task { try await viewModel.updateUserData() }
                    dismiss()
                } label: {
                    Text("Save")
                        .foregroundStyle(.white)
                        .font(.caption)
                        .frame(width: 50, height: 25)
                        .background(.purple)
                        .clipShape(Rectangle()).cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            EventFieldColumn(image: "face.smiling", title: " Emoji", placeholder: "", value: $viewModel.emoji)
            EventFieldColumn(image: "line.3.horizontal", title: " Title", placeholder: "", value: $viewModel.title)
            EventFieldColumn(image: "text.justify.left", title: " Description", placeholder: "Add a new description", value: $viewModel.description)
            
            
            HStack {
                HStack(spacing: 2) {
                    Image(systemName: "clock")
                        .imageScale(.medium)
                    
                    Text(" Date & time: ")
                }
                
                Spacer()
                
                DatePicker("", selection: $viewModel.startDate, displayedComponents: .date)
                    .foregroundColor(Color(.placeholderText))
                    .accentColor(Color(.purple.opacity(0.8)))
                    .frame(width: 110)
                
                DatePicker("", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    .frame(width: 90)
                
                
            }
            .padding(.horizontal)
            
            Button {
                showLocationView.toggle()
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "mappin.circle")
                        .imageScale(.medium)
                    
                    Text(" Location: ")
                    
                    Text(" \(viewModel.locationTitle ?? "")")
                    
                }
                .padding()
            }
            .sheet(isPresented: $showLocationView) {
                EventLocationSheet() { selectedTitle in
                    viewModel.locationTitle = selectedTitle
                }
            }
            
            Button {
                showInvitations.toggle()
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "envelope")
                        .imageScale(.medium )
                    
                    Text(" Invitations")
                }
                .padding()
            }
            .sheet(isPresented: $showInvitations) {
                InvitationsSheet()
                    .environmentObject(viewModel)
            }
            
            Spacer()
        }
        .onChange(of: viewModel.invitedUsers) { oldValue, newValue  in
            print("Invited users changed to: \(newValue.map(\.username).joined(separator: ", "))")
        }
    }
}

struct EventFieldColumn: View {
    
    let image: String
    let title: String
    let placeholder: String
    @Binding var value: String?
    
    var body: some View {
        HStack(spacing: 2) {
            
            Image(systemName: image)
                .imageScale(.medium)
            
            Text("\(title): ")
                .foregroundStyle(.black)
            
            TextField(placeholder, text: Binding(
                get: { value ?? "" },
                set: { value = $0.isEmpty ? nil : $0 }
            ))
            
            Spacer()
        }
        .padding()
    }
}
