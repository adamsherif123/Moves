//
//  EventRowView.swift
//  Moves
//
//  Created by Adam Sherif on 2/25/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct EventView: View {
    let user: User
    let event: Event
    
    @StateObject var eventViewModel: EventViewModel
    
    @State private var delete = false
    @State private var editEvent = false
    @State private var ditch = false
    @State private var report = false
    
    @Environment(\.dismiss) var dismiss
    
    init(user: User, event: Event) {
        self.user = user
        self.event = event
        self._eventViewModel = StateObject(wrappedValue: EventViewModel(event: event))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    UserCell(user: user, isEvent: true, isRSVPd: false)
                    
                        
                    if event.ownerUid == Auth.auth().currentUser?.uid {
                        Menu {
                            Button(action: {
                                editEvent.toggle()
                            }) {
                                Label("Edit Event", systemImage: "square.and.pencil")
                            }
                            
                            Button(action: {
                                delete.toggle()
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.black)
                                .imageScale(.large)
                        }
                        .alert("Are you sure you want to delete this event?", isPresented: $delete) {
                            Button("Yes", role: .destructive) {
                                Task { try await eventViewModel.deleteEvent() }
                                dismiss()
                            }
                            Button("No", role: .cancel) { }
                        }
                        
                    } else {
                        Menu {
                            Button(action: {
                                report.toggle()
                            }) {
                                Label("Report", systemImage: "house")
                            }
                            
                            Button(action: {
                                ditch.toggle()
                            }) {
                                Label("Ditch", systemImage: "multiply")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.black)
                                .imageScale(.large)
                        }
                        .alert("Are you sure you want to ditch this event?", isPresented: $ditch) {
                            Button("Yes", role: .destructive) {
                                Task { try await eventViewModel.ditch() }
                                dismiss()
                            }
                            Button("No", role: .cancel) { }
                        }
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $editEvent) {
                    EditEventView(event: event)
                }
                
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
                    .environmentObject(eventViewModel)
                    .padding()
                
                HStack {
                    
                    Spacer()
                    
                    let isRsvpd = eventViewModel.isRSVPd ?? false 
                        Button {
                        if isRsvpd {
                            Task { try await eventViewModel.unrsvp() }
                        } else {
                            Task { try await eventViewModel.rsvp() }
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
            Task {
                try await eventViewModel.checkIfRSVPd()
                try await eventViewModel.fetchInvitedUsers(eventId: event.id)
            }
        }
    }
    
    func formattedEventTime(from timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }

}


