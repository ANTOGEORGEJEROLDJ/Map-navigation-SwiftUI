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
        guard let sourceCoordinate = userLocation else { return }
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destPlacemark = MKPlacemark(coordinate: destination)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        request.transportType = .automobile

        MKDirections(request: request).calculate { response, error in
            if let route = response?.routes.first {
                DispatchQueue.main.async {
                    self.route = route
                }
            }
        }
    }
}






//import Foundation
//import CoreLocation
//import UIKit
//import MapKit
//
//
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var userLocation: CLLocationCoordinate2D?
//    @Published var locations: [Location] = []
//    
//    private let manager = CLLocationManager()
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//        loadLocations()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let coordinate = locations.first?.coordinate else { return }
//        DispatchQueue.main.async {
//            self.userLocation = coordinate
//        }
//    }
//
//    private func loadLocations() {
//        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json") else { return }
//        do {
//            let data = try Data(contentsOf: url)
//            self.locations = try JSONDecoder().decode([Location].self, from: data)
//        } catch {
//            print("Error decoding locations: \(error)")
//        }
//    }
//
//    func openInMaps(_ location: Location) {
//        let placemark = MKPlacemark(coordinate: location.coordination)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = location.name
//        mapItem.openInMaps(launchOptions: [
//            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
//        ])
//    }
//}
