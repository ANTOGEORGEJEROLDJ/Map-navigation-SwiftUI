

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
    @State private var showFloatingCard = true

    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
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
                        withAnimation {
                            viewModel.selectedLocation = location
                            region.center = location.coordinate
                            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // zoom in
                            showFloatingCard = true // <--- this brings back the card

                        }
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
//            .ignoresSafeArea()
            
            
            
            // Route overlay
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
            
            // Zoom In/Out Buttons
            VStack {
                Button("+") {
                    zoomIn()
                }
                .padding()
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4)
                .font(.title)
                .bold()
                
                Button("-") {
                    zoomOut()
                }
                .padding()
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4)
                .font(.title)
                .bold()
            }
            .padding(.leading, 300)
            .padding(.top, -350)
            
            // Floating shop card
            if let selected = viewModel.selectedLocation,showFloatingCard {
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selected.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(selected.address)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(.white.opacity(5))
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    .padding(.bottom, 250)
                }
                .transition(.move(edge: .bottom))
            }
            
           
            // Floating card + Route Buttons
                        if let selected = viewModel.selectedLocation {
                            VStack {
                                Spacer()
                                VStack(alignment: .leading) {
//                                    HStack {
//                                        VStack(alignment: .leading, spacing: 4) {
//                                            Text(selected.name)
//                                                .font(.headline)
//                                            Text(selected.address)
//                                                .font(.subheadline)
//                                                .foregroundColor(.gray)
//                                                .lineLimit(1)
//                                        }
//                                        Spacer()
//                                    }

                                    HStack {
                                        Button("Navigate") {
                                            viewModel.getRoute(to: selected.coordinate)
                                            showFloatingCard = false
                                            
                                        }
                                        .frame(width: 100)
                                        .padding(.vertical, 8)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)

                                        Button("Cancel") {
                                            viewModel.selectedLocation = nil
                                            viewModel.route = nil
                                            showFloatingCard = false
                                        }
                                        .frame(width: 100)
                                        .padding(.vertical, 8)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                                .padding(.bottom, 40)
                            }
                            .transition(.move(edge: .bottom))
                        }
                    }
                }
            
    
    private func zoomIn() {
        var newLatitudeDelta = region.span.latitudeDelta - zoomStep
        var newLongitudeDelta = region.span.longitudeDelta - zoomStep
        newLatitudeDelta = max(newLatitudeDelta, 0.005)
        newLongitudeDelta = max(newLongitudeDelta, 0.005)
        region.span = MKCoordinateSpan(latitudeDelta: newLatitudeDelta, longitudeDelta: newLongitudeDelta)
    }

    private func zoomOut() {
        var newLatitudeDelta = region.span.latitudeDelta + zoomStep
        var newLongitudeDelta = region.span.longitudeDelta + zoomStep
        newLatitudeDelta = min(newLatitudeDelta, 1.5)
        newLongitudeDelta = min(newLongitudeDelta, 1.5)
        region.span = MKCoordinateSpan(latitudeDelta: newLatitudeDelta, longitudeDelta: newLongitudeDelta)
    }
}

#Preview {
    ContentView()
}
