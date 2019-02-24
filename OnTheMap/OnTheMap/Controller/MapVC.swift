//
//  MapVC.swift
//  OnTheMap

//  Copyright © 2019 Reem AlSalloom. All rights reserved.
// Sample Pin code from udacity

import UIKit
import MapKit

class MapVC: Base, MKMapViewDelegate {
    
    //CLLocationManagerDelegate
    
    @IBOutlet weak var mapView: MKMapView!
   // var locationManager : CLLocationManager!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
          self.mapView.delegate = self
//        self.locationManager = CLLocationManager()
//        self.locationManager.delegate = self
//
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.startUpdatingLocation()
//        
        
    }
    
    override var locationData: LocationData? {
        didSet {
            updatePins()
        }
    }
    
    func updatePins()
    {
       // mapView.removeAnnotation(mapView?.annotations as! MKAnnotation)
        
        guard let locations = locationData?.studentLocations else {return}
        
        var annotations: [MKPointAnnotation] = []
        
        for location in locations  {
            
            let long = CLLocationDegrees (location.longitude)
            let lat = CLLocationDegrees (location.latitude )
            
            
            let first = location.firstName ?? " "
            let last = location.lastName ?? " "
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D (latitude: lat, longitude: long)
            annotation.title = "\(first) \(last)"
            annotation.subtitle = location.mediaURL
            
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = view.annotation?.subtitle! {
                app.open(URL(string: url)!, options: [:], completionHandler: nil)
            }
        }
    }
}
