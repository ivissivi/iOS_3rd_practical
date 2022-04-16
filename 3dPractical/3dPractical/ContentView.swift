//
//  ContentView.swift
//  3dPractical
//
//  Created by user215333 on 3/12/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var isModalPresented = false
    @State private var showsUserLocation = false
    
    var body: some View {
        VStack {
            Text("CONTENT VIEW")
                .padding()
            Button("Filters") {
                isModalPresented = true
            }
            MapView(isUserLocationVisible: $showsUserLocation)
        }
        .sheet(isPresented: $isModalPresented) {
            ModalView(isPresented: $isModalPresented, showsUserLocation: $showsUserLocation)
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var isUserLocationVisible: Bool
    typealias UIViewType = MKMapView
    @State private var isLUClicked = false
    @State private var isRSUClicked = false
    @State private var isBATClicked = false
    
    func makeUIView(context: Context) -> MKMapView {
        
        let locationManager = LocationManager()
        
        var userLatitude: Float {
            return Float(CLLocationManager().location?.coordinate.latitude ?? 0)
           }
           
        var userLongitude: Float {
               return Float(CLLocationManager().location?.coordinate.longitude ?? 0)
           }

        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let regionCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(userLongitude), longitude: CLLocationDegrees(userLongitude))
        
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        
        let region = MKCoordinateRegion(center: regionCoordinate, span: regionSpan)
        
        mapView.setRegion(region, animated: true)
        
        let latvijasUniversitate = MKPointAnnotation()
        latvijasUniversitate.coordinate = CLLocationCoordinate2D(latitude: 56.95, longitude: 24.1167)
        latvijasUniversitate.title = "LU"
        
        let rigasStradinaUniversitate = MKPointAnnotation()
        rigasStradinaUniversitate.coordinate = CLLocationCoordinate2D(latitude: 56.9328703, longitude: 24.0682983)
        rigasStradinaUniversitate.title = "RSU"
        
        let biznesaAugstskolaTuriba = MKPointAnnotation()
        biznesaAugstskolaTuriba.coordinate = CLLocationCoordinate2D(latitude: 56.9105, longitude: 24.08)
        biznesaAugstskolaTuriba.title = "BAT"
        
        let userLocation = MKPointAnnotation()
        userLocation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(userLatitude), longitude: CLLocationDegrees(userLongitude))
        
        mapView.addAnnotations([latvijasUniversitate, rigasStradinaUniversitate, biznesaAugstskolaTuriba])
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: biznesaAugstskolaTuriba.coordinate))
        request.transportType = .automobile
            
        let directions = MKDirections(request: request)
        directions.calculate {response, error in
        guard let route = response?.routes.first else { return }
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32), animated: true)
        mapView.addOverlay(route.polyline)
        }
        
        return mapView
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let line = MKPolylineRenderer(overlay: overlay)
            line.strokeColor = .systemRed
            line.lineWidth = 3
            
            return line
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = isUserLocationVisible
    }
}

