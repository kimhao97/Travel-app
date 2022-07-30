//
//  DirectionViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/22/21.
//

import UIKit
import MapKit
import CoreLocation

class DirectionViewController: BaseViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    private var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupData() {
        super.setupData()
    
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func setupUI() {
        super.setupUI()
        
        hideNavigationBar(animated: false)
        checkLocationServices()
    }
    
    // MARK: - Private Func
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
        checkLocationAuthorization()
      } else {
        // Show alert letting the user know they have to turn this on.
        print("Location services are not enabled")
      }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied: // Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        @unknown default:
                break
        }
    }
    
    private func direction(from soureCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: soureCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let destinationPin = MKPointAnnotation()
        destinationPin.coordinate = destinationCoordinate
        self.mapView.addAnnotation(destinationPin)
        
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, _ in
            guard let unwrappedResponse = response else { return }
            
//            for route in unwrappedResponse.routes {
//                self.mapView.addOverlay(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//                let distance: Float = Float(route.distance / 1000)
//                distanceLabel.text = String(format: "%.1fkm", distance)
//            }
            
            let route = unwrappedResponse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            distanceLabel.text = String(format: "%.1fkm", Float(route.distance / 1000))
        }
    }

}

extension DirectionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
//            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            let userCoordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: userCoordinate, span: span)
            mapView.setRegion(region, animated: false)
            
            let destination = CLLocationCoordinate2D(latitude: 40.76179701917036, longitude: -73.99898209708284)
            direction(from: userCoordinate, to: destination)
        }
    }
}

extension DirectionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "ic-mark")
            return pin

        } else {
            let pin = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "ic-markDestination")
            return pin
        }
    }
}
