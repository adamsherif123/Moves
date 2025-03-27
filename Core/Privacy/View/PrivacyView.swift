//
//  PrivacyView.swift
//  Moves
//
//  Created by Adam Sherif on 3/24/25.
//

import SwiftUI
import Kingfisher

enum PrivacySelection: Int, CaseIterable {
    case map
    case calendar
    
    var title: String {
        switch self {
        case .map: return "Map"
        case .calendar: return "Calendar"
        }
    }
    
    var frameSize: CGSize {
        switch self {
        case .map: return CGSize(width: 70, height: 32)
        case .calendar: return CGSize(width: 85, height: 32)
        }
    }
}

struct PrivacyView: View {
    
    @State private var selectedFilter: PrivacySelection = .map
    @StateObject var viewModel: PrivacyViewModel
    
    let user: User
    
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: PrivacyViewModel(user: user))
        self.user = user
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(PrivacySelection.allCases, id: \.self) { item in
                    Button {
                        withAnimation {
                            self.selectedFilter = item
                        }
                    } label: {
                        Text(item.title)
                            .fontWeight(.semibold)
                            .font(.caption)
                            .foregroundColor(.black)
                            .frame(width: item.frameSize.width, height: item.frameSize.height)
                            .background(RoundedRectangle(cornerRadius: 10).fill(selectedFilter == item ? Color(.purple.opacity(0.4)): Color(.systemGray5)))
                    }
                }
            }
            .padding(.vertical)
            
            
            TabView(selection: $selectedFilter) {
                mapPrivacyView.tag(PrivacySelection.map)
                calendarPrivacyView.tag(PrivacySelection.calendar)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar(.hidden, for: .tabBar)
        
    }
}

extension PrivacyView {
    var mapPrivacyView: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Text("Who can see my location")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            UserProfileImage(user: user, width: 40, height: 40, imageScale: .small)
                            
                            VStack(alignment: .leading) {
                                Text("Off the grid")
                                    .font(.headline)
                                
                                Text("When your off the grid, no one can see your location")
                                    .foregroundStyle(.gray)
                                    .font(.footnote)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $viewModel.isOffTheGrid)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .purple))
                                .onChange(of: viewModel.isOffTheGrid) { oldValue, newValue in
                                    Task { try await viewModel.toggleOffTheGrid() }
                                    print("Old value:\(oldValue), new value:\(newValue)")
                                }
                        }
                        .padding(12)
                    }
                    .background(.white)
                    .cornerRadius(14)
                    .shadow(color: Color.gray.opacity(0.7), radius: 10, x: 0, y: 2)
                    .padding(.horizontal, 12)
                    
                    
                }
                
                VStack(alignment: .leading) {
                    Text("👻 Ghosting hides your location from that friend, 😎 casual friends only see you when they're nearby, and ❤️ close friends can see your location at all times")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.horizontal)
                    
                    VStack {
                        LazyVStack {
                            ForEach(viewModel.friends) { friend in
                                VStack {
                                    HStack {
                                        UserCell(user: friend, isEvent: false, isRSVPd: false)
                                        
                                        Spacer()
                                        
                                        Button {
                                            Task {
                                                switch friend.privacyType {
                                                case "casual":
                                                    try await viewModel.makeCloseFriend(friend: friend)
                                                case "close":
                                                    try await viewModel.makeGhostFriend(friend: friend)
                                                default:
                                                    try await viewModel.makeCasualFriend(friend: friend)
                                                }
                                            }
                                        } label: {
                                            let type = friend.privacyType ?? "casual"
                                            Text(labelForType(type))
                                                .font(.footnote)
                                                .foregroundColor(fgColorForType(type))
                                                .padding(8)
                                                .background(bgColorForType(type))
                                                .shadow(color: Color.gray.opacity(0.7), radius: 10, x: 0, y: 2)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                        }
                                    }
                                    
                                    Divider()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(.top)
                        .background(.white)
                        .cornerRadius(14)
                        .shadow(color: Color.gray.opacity(0.7), radius: 10, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.top, 4)
                    }
                }
                .padding(.top)
            }
        }
    }
    
    var calendarPrivacyView: some View {
        VStack {
            Text("Calendar Privacy")
            
            
            
            Spacer()
        }
    }
    
    private func labelForType(_ type: String) -> String {
            switch type {
            case "ghost": return "👻Ghosting"
            case "close": return "❤️Close"
            default:      return "😎Casual"
            }
        }
        
        private func fgColorForType(_ type: String) -> Color {
            switch type {
            case "ghost": return .black
            case "close": return .white
            default:      return .white
            }
        }
        
        private func bgColorForType(_ type: String) -> Color {
            switch type {
            case "ghost": return .white
            case "close": return .green
            default:      return .orange
            }
        }
}
