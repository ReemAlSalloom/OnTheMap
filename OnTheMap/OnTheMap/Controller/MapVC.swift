//
//  MapVC.swift
//  OnTheMap
//
//
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
// Sample Pin code from udacity

import UIKit
import MapKit

class MapVC: Base, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    
    override var locationData: LocationData? {
        didSet {
            updatePins()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.mapView.delegate = self 
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        <#code#>
//    }
    func updatePins()
    {
        guard let locations = locationData?.studentLocations else {return}
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            
            let long = CLLocationDegrees (location.longitude)
            let lat = CLLocationDegrees (location.latitude )
            
            let coords = CLLocationCoordinate2D (latitude: lat, longitude: long)
            let mediaURL = location.mediaURL
            let first = location.firstName ?? " "
            let last = location.lastName ?? " "
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append (annotation)
        }
        self.mapView.addAnnotations (annotations)
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
