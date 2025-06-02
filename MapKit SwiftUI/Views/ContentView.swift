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
    
    // Zoom step
       let zoomStep = 0.02
    
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
//                .mapStyle(.hybrid(elevation:.realistic))
            
            VStack{
                Button("+"){
                    zoomIn()
                }
                
                .padding()
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(2))
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4)
                .font(.title)
                .bold()
               
                
                Button("-"){
                    zoomOut()
                }
                .padding()
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(2))
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4)
                .font(.title)
                .bold()
                
                  
                
            }
            .padding(.leading, 300)
            .padding(.top, -350)
                
            
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
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
                .padding(.bottom, 120)
                .padding(.horizontal, 5)
                
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
                        Spacer()
                        Button("Navigate") {
                            viewModel.getRoute(to: selected.coordinate)
                        }
                        .frame(width: 70)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.green.opacity(7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        
                        Button("Cancel") {
                            viewModel.selectedLocation = nil
                            viewModel.route = nil
                        }
                        .frame(width: 70)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
        }
        
    }
    // Zoom in function
        private func zoomIn() {
            var newLatitudeDelta = region.span.latitudeDelta - zoomStep
            var newLongitudeDelta = region.span.longitudeDelta - zoomStep
            
            // Minimum zoom level to avoid zooming too close
            newLatitudeDelta = max(newLatitudeDelta, 0.005)
            newLongitudeDelta = max(newLongitudeDelta, 0.005)
            
            region.span = MKCoordinateSpan(latitudeDelta: newLatitudeDelta, longitudeDelta: newLongitudeDelta)
        }
        
        // Zoom out function
        private func zoomOut() {
            var newLatitudeDelta = region.span.latitudeDelta + zoomStep
            var newLongitudeDelta = region.span.longitudeDelta + zoomStep
            
            // Maximum zoom level to avoid zooming too far
            newLatitudeDelta = min(newLatitudeDelta, 1.5)
            newLongitudeDelta = min(newLongitudeDelta, 1.5)
            
            region.span = MKCoordinateSpan(latitudeDelta: newLatitudeDelta, longitudeDelta: newLongitudeDelta)
        }
}


#Preview {
    ContentView()
}



