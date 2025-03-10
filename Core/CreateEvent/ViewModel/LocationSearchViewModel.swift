//
//  LocationSearchViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 3/7/25.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinates: CLLocationCoordinate2D?
    @Published var selectedLatitude: Double?
    @Published var selectedLongitude: Double?
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    static let shared = LocationSearchViewModel()
    
    var queryFragmnet: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragmnet
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragmnet
    }
    
    
    func selectLoction(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            
            if let error = error {
                print("DEBUG: Failed to get location coordinates with error: \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selectedLocationCoordinates = coordinate
            
            self.selectedLatitude = coordinate.latitude
            self.selectedLongitude = coordinate.longitude
            
            print("DEBUG: location coordinates \(coordinate)")
            
            print("DEBUG: selected latitude in view model \(self.selectedLatitude ?? 0.0)")
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
        
    }
}


extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
