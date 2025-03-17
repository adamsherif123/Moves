//
//  LocationManager.swift
//  Moves
//
//  Created by Adam Sherif on 3/16/25.
//

import Foundation
import CoreLocation
import FirebaseAuth
import FirebaseFirestore


class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }

    private func updateUserLocationInFirestore(latitude: Double, longitude: Double) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude
        ]
        
        try await Firestore.firestore()
            .collection("users")
            .document(currentUid)
            .updateData(data)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("DEBUG: Location Not determined")
        case .restricted:
            print("DEBUG: Location restricted")
        case .denied:
            print("DEBUG: Location denied")
        case .authorizedAlways:
            print("DEBUG: Location authorized always")
        case .authorizedWhenInUse:
            print("DEBUG: Location authorized when in use")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        
        Task {
            do {
                try await updateUserLocationInFirestore(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            } catch {
                print("DEBUG: Error updating user location in Firestore: \(error.localizedDescription)")
            }
        }
    }
}
