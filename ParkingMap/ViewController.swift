//
//  ViewController.swift
//  ParkingMap

//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .satellite
            mapView.delegate = self
        }
    }
    
    
    var locations = [MKAnnotation]()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Map View"
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let northGarageSpots = [0,5,20,62,100]
        let westGarageSpots = [1,2,3,4]
        let southGarageSpots = [5,2,32,34]
        
        //Setting Pins
        showParkingPin(title: "North Parking Garage", availableSpotsOnEachFloor: northGarageSpots, latitude: 37.338999, longitude: -121.880696, image: #imageLiteral(resourceName: "NorthLot"))
        showParkingPin(title: "West Parking Garage", availableSpotsOnEachFloor: westGarageSpots,  latitude: 37.332159, longitude: -121.882897, image: #imageLiteral(resourceName: "WestLot"))
        showParkingPin(title: "South Parking Garage", availableSpotsOnEachFloor: southGarageSpots, latitude: 37.333314, longitude: -121.880437, image: #imageLiteral(resourceName: "SouthLot"))
        
        mapView.showAnnotations(locations, animated: true)
        
    }
    
    func locationManager(_ manager : CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let locValue: CLLocation = locations.last!
        let center = CLLocationCoordinate2D(latitude: locValue.coordinate.latitude, longitude: locValue.coordinate.longitude)
        _ = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        //self.mapView.setRegion(region,animated:true)
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors:" + error.localizedDescription)
    }
    
    //MARK: ANNOTATIONS
    
    func showParkingPin(title: String, availableSpotsOnEachFloor:[Int], latitude: Double, longitude: Double, image: UIImage) {
        var location = CLLocationCoordinate2D()
        location.latitude = latitude
        location.longitude = longitude
        let parkingGarage = ParkingPin(title: title, locationName: title, availableSpotsOnEachFloor: availableSpotsOnEachFloor, coordinate: location, image: image)
        self.mapView.addAnnotation(parkingGarage)
        locations.append(parkingGarage)
    }
    
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        
        var annotationView: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.canShowCallout = true
            
        } else {
            annotationView.annotation = annotation
        }
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        
        let annotationLocation = annotationView.annotation?.coordinate
        let userLocation = mapView.userLocation.coordinate
        let isEqual = locationsAreEqual(annotationLocation: annotationLocation!,userLoc: userLocation)
        if isEqual{
        return annotationView
        }
        return nil
    }
    
    func locationsAreEqual(annotationLocation: CLLocationCoordinate2D , userLoc: CLLocationCoordinate2D) -> Bool {
        if (annotationLocation.latitude != userLoc.latitude) && (annotationLocation.longitude != userLoc.longitude) {
            return true
        }
        return false
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        _ = view.annotation as! ParkingPin
//        _ = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        showRouteOnMap(source: locationManager.location!, destination: view.annotation!)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "Show Info", sender: view)
        }
    }
    //MARK: DIRECTIONS
    
    func showRouteOnMap(source: CLLocation, destination: MKAnnotation) {
        self.mapView.removeOverlays(self.mapView.overlays)
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                self.mapView.add(unwrappedResponse.routes[0].polyline)
                self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }


    
    //MARK: NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? InfoViewController
        let annotationView = sender as? MKAnnotationView
        let annotation = annotationView?.annotation as? ParkingPin
        if segue.identifier == "Show Info" {
                destination?.waypointToEdit = annotation
        }
    }
    
    
    
    
}

