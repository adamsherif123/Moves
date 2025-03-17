//
//  CreateEventViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/4/25.
//

import Foundation
import Firebase
import FirebaseAuth

class CreateEventViewModel: ObservableObject {
    @Published var friends = [User]()
    
    @Published var startDate = Date()
    @Published var startTime = Date()
    @Published var selectedEmoji: EmojiViewModel? = nil
    @Published var title = ""
    @Published var location = ""
    @Published var description = ""
    @Published var isPublic = false
    @Published var isPrivate = true
    
    @Published var selectedFriends: [User] = []
    
    @Published var titleOfLocation: String = ""
    
    @MainActor
    func fetchFriends() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let userFriends = try await UserService.fetchUserFriends(withUid: currentUid)
        
        self.friends = userFriends
    }
    
    func createEvent() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let emoji = selectedEmoji?.title ?? ""
        
        var friendIds = selectedFriends.map { $0.id }
        friendIds.append(currentUid)
        
        let eventId = NSUUID().uuidString
        
        await uploadEventData(id: eventId,
                              emoji: emoji,
                              title: title,
                              description: description,
                              time: Timestamp(date: startTime),
                              locationTitle: titleOfLocation,
                              latitude: LocationSearchViewModel.shared.selectedLatitude,
                              longitude: LocationSearchViewModel.shared.selectedLongitude,
                              ownerUid: currentUid,
                              createdAt: Timestamp(date: .now),
                              invitesUids: friendIds)
        
        try? await Firestore.firestore()
                .collection("events")
                .document(eventId)
                .collection("rsvpedUsers")
                .document(currentUid)
                .setData([:])
        
        for friend in friendIds where friend != currentUid {
            try await Firestore.firestore().collection("users")
                .document(friend).collection("invitedEvents").document(eventId).setData([:])
        }
    }
    
    func uploadEventData(id: String,
                         emoji: String,
                         title: String,
                         description: String?,
                         time: Timestamp,
                         locationTitle: String?,
                         latitude: Double?,
                         longitude: Double?,
                         ownerUid: String,
                         createdAt: Timestamp,
                         invitesUids: [String] = [] ) async {
        
        let event = Event(id: id,
                          emoji: emoji,
                          title: title,
                          description: description,
                          time: time,
                          locationTitle: locationTitle,
                          latitude: latitude,
                          longitude: longitude,
                          ownerUid: ownerUid,
                          createdAt: createdAt,
                          invitesUids: invitesUids)
        
        guard let encodedEvent = try? Firestore.Encoder().encode(event) else { return }
        
        try? await Firestore.firestore().collection("events").document(event.id).setData(encodedEvent)
        
    }
    
    func combinedEventTime(date: Date, time: Date) -> Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second
        
        return calendar.date(from: mergedComponents)
    }

}
