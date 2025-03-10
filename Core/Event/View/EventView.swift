//
//  EventRowView.swift
//  Moves
//
//  Created by Adam Sherif on 2/25/25.
//

import SwiftUI
import Firebase

struct EventView: View {
    let user: User
    let event: Event
    @EnvironmentObject var viewModel: MapAnnotationsViewModel
    @StateObject var eventViewModel = EventViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    UserCell(user: user, isEvent: true, isRSVPd: false)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.black)
                            .imageScale(.large)
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text(event.title)
                        .bold()
                        .font(.headline)
                    
                    if let locationTitle = event.locationTitle,
                       let latitude = event.latitude,
                       let longitude = event.longitude,
                       let mapsURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)") {
                        Link(destination: mapsURL) {
                            Text(locationTitle)
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                                .underline()
                                .bold()
                        }
                    }
                    
                    if let eventTime = event.time {
                        Text(formattedEventTime(from: eventTime))
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    
                }
                .padding(.horizontal)
                
                GoingCircles(event: event)
                    .environmentObject(viewModel)
                    .padding()
                
                HStack {
                    
                    Spacer()
                    
                    let isRsvpd = eventViewModel.isRSVPd ?? false 
                        Button {
                        if isRsvpd {
                            Task { try await eventViewModel.unrsvp(eventId: event.id) }
                        } else {
                            Task { try await eventViewModel.rsvp(eventId: event.id) }
                        }
                    } label: {
                        Text(isRsvpd ? "unRSVP" : "RSVP")
                            .foregroundStyle(isRsvpd ? .black : .white)
                            .font(.caption)
                            .frame(width: 120, height: 25)
                            .background(isRsvpd ? Color(.systemGray5) : .purple)
                            .clipShape(Rectangle()).cornerRadius(10)
                    }
                    
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .tint(.black)
        .onAppear {
            Task { try await eventViewModel.checkIfRSVPd(eventId: event.id) }
        }
    }
    
    func formattedEventTime(from timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }

}

#Preview {
    EventView(user: DeveloperPreview.user, event: DeveloperPreview.event)
}
