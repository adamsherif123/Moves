//
//  MapPinItem.swift
//  Moves
//
//  Created by Adam Sherif on 3/7/25.
//

import Foundation
import MapKit

struct MapPinItem: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let pinType: MapPinType
}
