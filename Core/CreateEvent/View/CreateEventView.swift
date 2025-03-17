//
//  CreateEventView.swift
//  Moves
//
//  Created by Adam Sherif on 1/15/25.
//

import SwiftUI

enum DestinationSearchOptions {
    case emojis
    case dates
    case description
    case invites
}

struct CreateEventView: View {
    
    @State private var selectedOption: DestinationSearchOptions = .emojis
    @State private var showLocationSheet = false
    
    @Environment(\.dismiss) var dismiss
        
    @StateObject var viewModel = CreateEventViewModel()
    
    var isFormValid: Bool {
        guard viewModel.selectedEmoji != nil,
              !viewModel.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !viewModel.titleOfLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !viewModel.selectedFriends.isEmpty
        else {
            return false
        }
        
        guard let eventTime = viewModel.combinedEventTime(date: viewModel.startDate, time: viewModel.startTime) else {
            return false
        }
        
        if eventTime <= Date() {
            return false
        }
        
        return true
    }

    
    var body: some View {
        VStack {
            emojis
            
            dates
            
            descriptionView
            
            invites
            
            Spacer()
        }
        .padding(.top, 24)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Create Event")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { try await viewModel.createEvent() }
                    dismiss()
                } label: {
                    Text("Create")
                        .foregroundStyle(.white)
                        .font(.caption)
                        .frame(width: 80, height: 25)
                        .background(isFormValid ? Color.purple : Color.purple.opacity(0.5))
                        .clipShape(Rectangle()).cornerRadius(10)
                }
                .disabled(!isFormValid)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task { try await viewModel.fetchFriends() }
        }
        .onChange(of: viewModel.selectedFriends) { oldValue, newValue in
            print(oldValue)
            print(newValue)
        }
        .sheet(isPresented: $showLocationSheet) {
            EventLocationSheet() { selectedTitle in
                viewModel.titleOfLocation = selectedTitle
            }
        }
        
    }
}

extension CreateEventView {
    var emojis: some View {
        VStack(alignment: .leading) {
            if selectedOption == .emojis {
                VStack(alignment: .leading) {
                    Text("What's happening?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    ScrollView (.horizontal, showsIndicators: false) {
                        LazyHStack (spacing: 25) {
                            ForEach(EmojiViewModel.allCases, id: \.rawValue) { item in
                                Button {
                                    if viewModel.selectedEmoji == item {
                                        viewModel.selectedEmoji = nil
                                    } else {
                                        viewModel.selectedEmoji = item
                                        withAnimation(.snappy) {
                                            selectedOption = .dates
                                        }
                                    }
                                } label: {
                                    Text(item.title)
                                        .padding(10)
                                        .font(.system(size: 25))
                                        .background(viewModel.selectedEmoji == item ? .purple.opacity(0.5) : .white)
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                        .shadow(radius: 5)
                                }
                            }
                        }
                        .frame(height: 80)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            } else {
                ColapsedPickerView(title: "What's happening?", description: viewModel.selectedEmoji == nil ? "":"🍳")
            }
            
        }
        .modifier(CollapsiableDestinationViewModifier())
        .frame(height: selectedOption == .emojis ? 170 : 64)
        .onTapGesture {
            withAnimation(.snappy) {
                selectedOption = .emojis
            }
        }
    }
    
    var dates: some View {
        VStack(alignment: .leading) {
            if selectedOption == .dates {
                HStack {
                    Text("Date and time")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.snappy) {
                            selectedOption = .description
                        }
                    } label: {
                        Text("Next")
                            .font(.subheadline)
                    }
                }
                
                VStack {
                    DatePicker("Date", selection: $viewModel.startDate, displayedComponents: .date)
                        .foregroundColor(Color(.placeholderText))
                        .accentColor(Color(.purple.opacity(0.8)))
                    
                    DatePicker("", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                }
                .foregroundStyle(.gray)
                .font(.subheadline)
                .fontWeight(.semibold)
                
            } else {
                ColapsedPickerView(title: "When?", description: "")
            }
        }
        .modifier(CollapsiableDestinationViewModifier())
        .frame(height: selectedOption == .dates ? 320 : 64)
        .onTapGesture {
            withAnimation(.snappy) {
                selectedOption = .dates
            }
        }
        .padding(.vertical, selectedOption == .dates ? 10:0)
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading) {
            if selectedOption == .description {
                HStack {
                    Text("Description")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.snappy) {
                            selectedOption = .invites
                        }
                    } label: {
                        Text("Next")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                }
                
                TextField("Title", text: $viewModel.title, axis: .vertical)
                    .padding(12)
                    .modifier(Modifierr())
                
                Button {
                    showLocationSheet.toggle()
                } label: {
                    if viewModel.titleOfLocation != "" {
                        Text("\(viewModel.titleOfLocation)")
                            .foregroundStyle(Color(.black))
                            .frame(width: 315, alignment: .leading)
                            .padding(12)
                            .font(.subheadline)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    } else {
                        Text("Location")
                            .foregroundStyle(Color(.placeholderText))
                            .frame(width: 315, alignment: .leading)
                            .padding(12)
                            .font(.subheadline)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                }
                
                
                
                
                TextField("Description", text: $viewModel.description, axis: .vertical)
                    .padding(12)
                    .padding(.bottom, 10)
                    .modifier(Modifierr())
                
                
            } else {
                ColapsedPickerView(title: "Add a description", description: "")
                
                
            }
        }
        .modifier(CollapsiableDestinationViewModifier())
        .frame(height: selectedOption == .description ? 280 : 64)
        .onTapGesture {
            withAnimation(.snappy) {
                selectedOption = .description
            }
        }
    }
    
    var invites: some View {
        VStack(alignment: .leading) {
            if selectedOption == .invites {
                
                VStack {
                    HStack {
                        Text("Send invites")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                    }
                    
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.isPublic = true
                                viewModel.isPrivate = false
                            }
                        } label: {
                            Text("Public")
                                .foregroundStyle(viewModel.isPublic ? .white : .black)
                                .font(.caption)
                                .frame(width: 80, height: 25)
                                .background(viewModel.isPublic ? .purple : Color(.systemGray5))
                                .clipShape(Rectangle()).cornerRadius(10)
                        }
                        
                        Button {
                            withAnimation() {
                                viewModel.isPrivate = true
                                viewModel.isPublic = false
                            }
                        } label: {
                            Text("Private")
                                .foregroundStyle(viewModel.isPrivate ? .white : .black)
                                .font(.caption)
                                .frame(width: 80, height: 25)
                                .background(viewModel.isPrivate ? .purple : Color(.systemGray5))
                                .clipShape(Rectangle()).cornerRadius(10)
                        }
                    }
                    
                    VStack {
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.friends) { friend in
                                    let isSelected = viewModel.selectedFriends.contains(where: { $0.id == friend.id })
                                    
                                    SelectableUserCell(user: friend, isSelected: isSelected) {
                                        if isSelected {
                                            withAnimation {
                                                viewModel.selectedFriends.removeAll { $0.id == friend.id }
                                            }
                                        } else {
                                            withAnimation {
                                                viewModel.selectedFriends.append(friend)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                ColapsedPickerView(title: "Who?", description: "")
            }
        }
        .modifier(CollapsiableDestinationViewModifier())
        .frame(height: selectedOption == .invites ? 490 : 64)
        .onTapGesture {
            withAnimation(.snappy) {
                selectedOption = .invites
            }
        }
    }
}

#Preview {
    CreateEventView()
}

struct ColapsedPickerView: View {
    
    let title: String
    let description: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text(description)
            }
            .fontWeight(.semibold)
            .font(.subheadline)
        }
    }
}

struct CollapsiableDestinationViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .shadow(radius: 10)
    }
}

struct Modifierr: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}
