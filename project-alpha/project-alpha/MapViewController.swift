//
//  MapViewController.swift
//  project-alpha
//
//  Created by Cher Moua on 11/27/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    //Map
    @IBOutlet weak var mapView: MKMapView!
    
    // the function called everytime the user moves 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] //Most recent position of our user
        
        // how zoomed in the map will be
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        mapView.setRegion(region, animated: true)

        // have the blue dot on the map show to represent the user location
        self.mapView.showsUserLocation = true
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // this allows the user use their location only when using the app. can change to always
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
