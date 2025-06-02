//
//  ContentView.swift
//  MapKit SwiftUI
//
//  Created by Paranjothi iOS MacBook Pro on 02/06/25.
//


import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewModel = LocationViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack {
            // Map View
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: viewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button {
                        viewModel.selectedLocation = location
                        viewModel.getRoute(to: location.coordinate)
                    } label: {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            Text(location.name)
                                .font(.caption2)
                                .padding(4)
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .overlay(
                Group {
                    if let route = viewModel.route {
                        MapOverLay(route: route)
                    }
                }
            )
            .onAppear {
                if let userLoc = viewModel.userLocation {
                    region.center = userLoc
                }
            }
            .ignoresSafeArea()

            // Live location button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if let loc = viewModel.userLocation {
                            region.center = loc
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }

            // Cancel route button when pin is selected
            if let selected = viewModel.selectedLocation {
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Navigating to:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(selected.name)
                                .font(.headline)
                        }
                        
                        Button("Cancel") {
                            viewModel.selectedLocation = nil
                            viewModel.route = nil
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .padding(.bottom, 70)
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}



//import SwiftUI
//import MapKit
//
//struct ContentView: View {
//    @StateObject var viewModel = LocationViewModel()
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    )
//
//    var body: some View {
//        ZStack {
//            if let _ = viewModel.userLocation {
//                Map(coordinateRegion: $region,
//                    showsUserLocation: true,
//                    annotationItems: viewModel.locations) { location in
//                    MapAnnotation(coordinate: location.coordination) {
//                        Button {
//                            viewModel.openInMaps(location)
//                        } label: {
//                            VStack {
//                                Image(systemName: "mappin.circle.fill")
//                                    .foregroundColor(.red)
//                                    .font(.title)
//                                Text(location.name)
//                                    .font(.caption)
//                                    .padding(4)
//                                    .background(.white)
//                                    .cornerRadius(5)
//                            }
//                        }
//                    }
//                }
//                .onAppear {
//                    if let userLoc = viewModel.userLocation {
//                        region.center = userLoc
//                    }
//                }
//                .edgesIgnoringSafeArea(.all)
//            } else {
//                ProgressView("Loading location...")
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
