//
//  MapOverLay.swift
//  MapKit SwiftUI
//
//  Created by Paranjothi iOS MacBook Pro on 02/06/25.
//

import SwiftUI
import MapKit

struct MapOverLay: UIViewRepresentable {
    var route: MKRoute?

        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.delegate = context.coordinator
            return mapView
        }

        func updateUIView(_ uiView: MKMapView, context: Context) {
            uiView.removeOverlays(uiView.overlays)
            if let route = route {
                uiView.addOverlay(route.polyline)
                let rect = route.polyline.boundingMapRect
                uiView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 150, right: 50), animated: true)
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator()
        }

        class Coordinator: NSObject, MKMapViewDelegate {
            func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                if let polyline = overlay as? MKPolyline {
                    let renderer = MKPolylineRenderer(polyline: polyline)
                    renderer.strokeColor = .blue
                    renderer.lineWidth = 4
                    return renderer
                }
                return MKOverlayRenderer()
            }
        }
}


