//
//  DeveloperPreview.swift
//  Moves
//
//  Created by Adam Sherif on 12/28/24.
//

import Foundation

struct DeveloperPreview {
    
    static var user = User (
        id: NSUUID().uuidString,
        email: "adamsherif167@gmail.com",
        username: "adamsherif_",
        fullName: "Adam Sherif",
        profileImageUrl: "&me",
        isCalendarPrivate: false,
        isMapPrivate: false,
        circlesCount: 0,
        friendsCount: 0
    )
    
    static var event = Event(
         id: NSUUID().uuidString,
         emoji: "🍴",
         title: "Test Event",
         latitude: 40.779434,
         longitude: -73.961402,
         ownerUid: DeveloperPreview.users[0].id,
         invitesUids: [DeveloperPreview.users[1].id, DeveloperPreview.users[2].id, DeveloperPreview.users[3].id]
    )
    
    static var events: [Event] = [
        .init(
            id: NSUUID().uuidString,
            emoji: "🍴",
            title: "Test Event",
            latitude: 40.773434,
            longitude: -73.969402,
            ownerUid: DeveloperPreview.users[0].id,
            invitesUids: [DeveloperPreview.users[2].id]
        ),
        
        .init(
            id: NSUUID().uuidString,
            emoji: "🔫",
            title: "Work",
            latitude: 40.775654,
            longitude: -73.966402,
            ownerUid: DeveloperPreview.users[2].id,
            invitesUids: [DeveloperPreview.users[1].id, DeveloperPreview.users[3].id, DeveloperPreview.users[2].id]
        ),
        
        .init(
            id: NSUUID().uuidString,
            emoji: "🙊",
            title: "Weed",
            latitude: 40.773284,
            longitude: -73.965402,
            ownerUid: DeveloperPreview.users[1].id,
            invitesUids: [DeveloperPreview.users[2].id, DeveloperPreview.users[3].id]
        ),
        
        .init(
            id: NSUUID().uuidString,
            emoji: "😍",
            title: "Dinner",
            latitude: 40.779004,
            longitude: -73.963402,
            ownerUid: DeveloperPreview.users[3].id,
            invitesUids: [DeveloperPreview.users[1].id]
        )
    ]
    
    
    static var users: [User] = [
        
        .init(
            id: NSUUID().uuidString,
            email: "mockuser1@gmail.com",
            username: "mock_user.1",
            fullName: "Hello World",
            profileImageUrl: "",
            isCalendarPrivate: false,
            isMapPrivate: false,
            circlesCount: 0,
            friendsCount: 0
//            latitude: 40.8075,
//            longitude: -73.9626
        ),
        .init(
            id: NSUUID().uuidString,
            email: "mockuser2@gmail.com",
            username: "mock_user.2",
            fullName: "Goodbye world",
            profileImageUrl: "mock_users_2",
            isCalendarPrivate: false,
            isMapPrivate: false,
            circlesCount: 0,
            friendsCount: 0
//            latitude: 40.8000,
//            longitude: -73.9580
        ),
        .init(
            id: NSUUID().uuidString,
            email: "mockuse3r@gmail.com",
            username: "mock_user.3",
            fullName: "John Jay",
            profileImageUrl: "mock_users_3",
            isCalendarPrivate: false,
            isMapPrivate: false,
            circlesCount: 0,
            friendsCount: 0
//            latitude: 40.8150,
//            longitude: -73.9700
        ),
        .init(
            id: NSUUID().uuidString,
            email: "mockuser4@gmail.com",
            username: "mock_user.4",
            fullName: "Leo Messi",
            profileImageUrl: "mock_users_4",
            isCalendarPrivate: false,
            isMapPrivate: false,
            circlesCount: 0,
            friendsCount: 0
//            latitude: 40.8020,
//            longitude: -73.9680
        ),
    ]
}
