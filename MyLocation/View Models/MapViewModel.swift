import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var searchText = ""
    @Published var places: [Place] = []
    @Published var region: MKCoordinateRegion!
    @Published var permissionDenied = false
    @Published var mapType: MKMapType = .standard
    
    var locationManager = CLLocationManager()
    var mapView = MapView()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func searchQuery() {
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        MKLocalSearch(request: request).start { (response, _) in
            guard let result = response else {
                return
            }
            
            self.places = result.mapItems.compactMap {
                Place(placemark: $0.placemark)
            }
        }
    }
    
    func selectPlace(place: Place) {
        searchText = ""
        
        guard let coordinate = place.placemark.location?.coordinate else {
            return
        }
        
        mapView.addAnnotation(coordinate: coordinate, name: place.placemark.name)
        mapView.setRegion(region: MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000))
    }

    func updateMapType() {
        if mapType == .standard {
            mapType = .hybrid
        }
        else {
            mapType = .standard
        }
        
        mapView.setMapType(mapType: mapType)
    }
    
    func focusLocation() {
        guard let _ = region else {
            return
        }
        
        mapView.setRegion(region: region)
    }
    
    func requestAuthorization() {
        if locationManager.authorizationStatus != .authorizedWhenInUse &&
            locationManager.authorizationStatus != .authorizedAlways {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .denied:
            permissionDenied = false
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region: region)
    }
}
