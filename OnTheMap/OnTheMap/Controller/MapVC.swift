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
    
//    override var locationData: LocationData? {
//        didSet {
//            guard let locationData = locationData else {return }
//            LocationData.studentLocations = LocationData.studentLocations.filter({ $0.firstName != nil && $0.firstName?.isEmpty == false})
//
//            updatePins()
//        }
//    }
    
    func updatePins()
    {
      //  mapView.removeAnnotation(mapView.annotations)
        
       // guard let locations =  LocationData.studentLocations? else {return}
         let locations =  LocationData.studentLocations
        var annotations: [MKPointAnnotation] = []
        
        for location in locations  {
            
            let long = CLLocationDegrees (location.longitude )
            let lat = CLLocationDegrees (location.latitude )
            
            
            let first = location.firstName ?? " "
            let last = location.lastName ?? " "
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D (latitude: lat, longitude: long)
            annotation.title = "\(first) \(last)"
            annotation.subtitle = location.mediaURL
            
            print(annotation.title )
            
            annotations.append (annotation)
        }
        self.mapView.addAnnotations (annotations)
        
    }}

extension MapVC {

    
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
            if  let subtitle = view.annotation?.subtitle  ,let url = URL(string: subtitle!), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
