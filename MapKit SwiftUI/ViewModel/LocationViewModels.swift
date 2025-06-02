//
//  LocationViewModels.swift
//  MapKit SwiftUI
//
//  Created by Paranjothi iOS MacBook Pro on 02/06/25.
//




import Foundation
import MapKit

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var locations: [Location] = []
    @Published var route: MKRoute?
    @Published var selectedLocation: Location?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        loadLocations()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first?.coordinate
    }

    private func loadLocations() {
        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json") else { return }
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Location].self, from: data) {
            self.locations = decoded
        }
    }

    func getRoute(to destination: CLLocationCoordinate2D) {
        guard let userLocation = userLocation else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                DispatchQueue.main.async {
                    self.route = route
                }
            }
        }
    }

    func clearSelection() {
        selectedLocation = nil
        route = nil
    }

}





