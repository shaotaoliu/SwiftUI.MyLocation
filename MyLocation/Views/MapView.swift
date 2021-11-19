import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    private var mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation.isKind(of: MKUserLocation.self) {
                return nil
            }
            
            let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
            pinAnnotation.tintColor = .red
            pinAnnotation.animatesDrop = true
            pinAnnotation.canShowCallout = true
            return pinAnnotation
        }
    }
}

extension MapView {
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, name: String?) {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = name
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnnotation)
    }
    
    func setRegion(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    func setMapType(mapType: MKMapType) {
        mapView.mapType = mapType
    }
}
