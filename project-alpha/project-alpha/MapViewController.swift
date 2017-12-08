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

class MapViewController: UIViewController {
  let mapView: MKMapView
  let locationManager: LocationManagerProtocol
  
  init(locationManger: LocationManagerProtocol = LocationManager.sharedManager) {
    self.mapView = MKMapView(forAutoLayout: ())
    self.locationManager = locationManger
    super.init(nibName: nil, bundle: nil)
    view.addSubview(mapView)
    mapView.autoPinEdgesToSuperviewEdges()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad(){
    super.viewDidLoad()
    locationManager.addObserver(self)
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }
}

extension MapViewController: CLLocationManagerDelegate {
  // the function called everytime the user moves
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //Most recent position of our user
    guard let location = locations.first else { return }
    
    // how zoomed in the map will be
    let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
    let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
    mapView.setRegion(region, animated: true)
    
    // have the blue dot on the map show to represent the user location
    self.mapView.showsUserLocation = true
  }
}
