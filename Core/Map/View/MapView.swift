//
//  MapView.swift
//  Moves
//
//  Created by Adam Sherif on 12/27/24.
//

import SwiftUI
import MapKit
import Kingfisher

enum MapPinType {
    case user(User)
    case event(Event)
}

struct MapView: View {
    
    let user: User
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.8075, longitude: -73.9626),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @StateObject var viewModel = MapAnnotationsViewModel()
    @ObservedObject var manager = LocationManager.shared
    
    @State private var selectedPin: MapPinItem?
    @State private var showTutorialSheet = false
    
    private var allPins: [MapPinItem] {
        
        let userPins =
        viewModel.users.map { user in
            MapPinItem(
                id: user.id,
                coordinate: CLLocationCoordinate2D(
                    latitude: user.latitude ?? 0.0,
                    longitude: user.longitude ?? 0.0
                ),
                pinType: .user(user)
            )
        }
        
        let eventPins = viewModel.events.map { event in
            MapPinItem(
                id: event.id,
                coordinate: CLLocationCoordinate2D(
                    latitude: event.latitude ?? 0.0,
                    longitude: event.longitude ?? 0.0
                ),
                pinType: .event(event)
            )
        }
        
        return userPins + eventPins
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Map(coordinateRegion: $region, annotationItems: allPins) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        
                        switch item.pinType {
                            
                        case .user(let user):
                            Button  {
                                selectedPin = item
                            } label: {
                                UserPin(user: user)
                            }
                            
                        case .event(let event):
                            Button {
                                selectedPin = item
                            } label: {
                                EventPin(event: event)
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .sheet(item: $selectedPin) { pin in
                    switch pin.pinType {
                    case .user(let user):
                        GuestUserProfileView(user: user)
                            .presentationDetents([.fraction(0.99)])
                    case .event(let event):
                        if let owner = event.user {
                            EventView(user: owner, event: event)
                                .presentationDetents([.fraction(0.5)])
                        }
                    }
                }
                
                HStack(alignment: .top) {
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass").bold()
                            .modifier(MapButtonModifier())
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 25) {
                        NavigationLink {
                            CreateEventView()
                        } label: {
                            Image(systemName: "pencil")
                                .modifier(MapButtonModifier())
                        }
                        
                        NavigationLink {
                            NotificationsView(user: user)
                                .environmentObject(viewModel)
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell")
                                    .modifier(MapButtonModifier())
                                
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.purple)
                            }
                                
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis.message")
                                .modifier(MapButtonModifier())
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "lock")
                                .modifier(MapButtonModifier())
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                Task {
                    try await viewModel.fetchUserEvents()
                    try await viewModel.fetchUsers()
                    if manager.userLocation == nil {
                        manager.requestLocation()
                    } else {
                        
                    }
                }
                
                print("HELOOOOO")
            }
        }
        
    }
}

struct UserPin: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 3) {
            if user.profileImageUrl == "" {
                ZStack {
                    Circle()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(Color(.systemGray3))
                    
                    Image(systemName: "person")
                        .foregroundStyle(.white)
                }
            } else {
                KFImage(URL(string: user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 35, height: 35)
            }
            
            HStack(spacing: 4) {
                if user.isCurrentUser {
                    Text("You")
                        .foregroundStyle(.black)
                        .font(.footnote)
                } else {
                    Text(extractFirstName(from: user.fullName))
                        .foregroundStyle(.black)
                        .font(.footnote)
                }
                
                Text("2m")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            .bold()
            .padding(4)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    func extractFirstName(from fullName: String?) -> String {
        guard let fullName = fullName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !fullName.isEmpty else {
            return ""
        }
        let nameParts = fullName.components(separatedBy: " ")
        
        return nameParts.first ?? ""
    }
}

struct EventPin: View {
    let event: Event
    
    var body: some View {
        VStack(spacing: 3) {
            Text(event.emoji)
                .font(.title)
            
            Text(event.title)
                .foregroundStyle(.black)
                .font(.footnote)
                .bold()
                .padding(4)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    MapView(user: DeveloperPreview.user)
}
