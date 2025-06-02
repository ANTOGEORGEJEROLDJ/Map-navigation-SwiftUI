//
//  MapOverLay.swift
//  MapKit SwiftUI
//
//  Created by Paranjothi iOS MacBook Pro on 02/06/25.
//

import SwiftUI
import MapKit

struct MapOverLay: UIViewRepresentable {
    let route: MKRoute

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addOverlay(route.polyline)
        let rect = route.polyline.boundingMapRect
        mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 100, right: 40), animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        uiView.addOverlay(route.polyline)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}


//#Preview {
//    MapOverLay(route: "")
//}
