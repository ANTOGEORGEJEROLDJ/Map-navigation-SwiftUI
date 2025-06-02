//
//  BesicMap.swift
//  MapKit SwiftUI
//
//  Created by Paranjothi iOS MacBook Pro on 02/06/25.
//
import MapKit
import SwiftUI

struct BesicMap: View {
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.003, longitude: -0.1278),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                                                             )
    )
    var body: some View {
        VStack {
            
            Map(position: $position)
                .mapStyle(.hybrid(elevation:.realistic))
                .onMapCameraChange(frequency: .continuous) { context in
                    print(context.region)
                }
            
            
            HStack(spacing: 50){
                Button("Parish"){
                    position = MapCameraPosition.region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                       )
                    )
                }
                .foregroundColor(.black)
                
                Button("Tokyo"){
                    position = MapCameraPosition.region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                       )
                    )
                }
                .foregroundColor(.black)
            }
        }
        .padding()
    }
}

#Preview {
    BesicMap()
}
