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
import Mapbox
import MapboxNavigation
import YAPI

class MapViewController: UIViewController {
  let mapView: MKMapView
  let mapBoxView: MGLMapView
  let locationManager: LocationManagerProtocol
  let source: MKMapItem
  let destination: MKMapItem
  
  init(locationManger: LocationManagerProtocol = LocationManager.sharedManager, source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
    self.mapView = MKMapView(forAutoLayout: ())
    self.mapBoxView = MGLMapView(style: .streets)
    self.locationManager = locationManger
    self.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
    self.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
    super.init(nibName: nil, bundle: nil)
//    view.addSubview(mapView)
//    mapView.autoPinEdgesToSuperviewEdges()
//    mapView.delegate = self
    view.addSubview(mapBoxView)
    mapBoxView.autoPinEdgesToSuperviewEdges()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad(){
    super.viewDidLoad()
    locationManager.addObserver(self)
    
    /*
    if locationManager.isLocationServiceEnabled {
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
      calculateDirections()
    }
    */
  }
  
  func calculateDirections() {
    let request = MKDirectionsRequest()
    
    request.source = source
    request.destination = destination
    
    request.requestsAlternateRoutes = true
    request.transportType = .walking
    
    let directions = MKDirections(request: request)
    directions.calculate { response, error in
      if let routes = response?.routes {
        let sortedRoutes = routes.sorted { $0.expectedTravelTime < $1.expectedTravelTime }
        guard let quickestRoute = sortedRoutes.first else {
          log(.warning, for: .general, message: "No routes found")
          return
        }
        for step in quickestRoute.steps {
          let points = step.polyline.points()
          for i in 0..<step.polyline.pointCount {
            print(points[i])
          }
          print(step.instructions)
        }
        self.show(routes: [quickestRoute])
      }
      else if let error = error {
        log(.error, for: .general, message: "Error getting directions: \(error)")
      }
    }
  }
}

extension MKRoute {
  func isOnRoute(point: CLLocationCoordinate2D, tolerance: CLLocationDistance) -> Bool {
    let toleranceSquared = tolerance * tolerance
    for step in self.steps {
      let points = step.polyline.points()
      for i in 0..<step.polyline.pointCount {
        let coordinate = MKCoordinateForMapPoint(points[i])
        let lat = coordinate.latitude - point.latitude
        let long = coordinate.longitude - point.longitude
        
        let distance = lat * lat + long * long
        if distance < toleranceSquared {
          return true
        }
      }
    }
    return false
  }
}

// MARK: Map drawing
extension MapViewController {
  func plotPolyline(route: MKRoute) {
    mapView.add(route.polyline)
    
    if mapView.overlays.count == 1 {
      mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                                animated: false)
    }
    else {
      let polylineBoundingRect = MKMapRectUnion(mapView.visibleMapRect, route.polyline.boundingMapRect)
      mapView.setVisibleMapRect(polylineBoundingRect,
                                edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                                animated: false)
    }
  }
  
  func show(routes: [MKRoute]) {
    for route in routes {
      plotPolyline(route: route)
    }
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let polylineRenderer = MKPolylineRenderer(overlay: overlay)
    if overlay is MKPolyline {
      polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
      polylineRenderer.lineWidth = 5
    }
    return polylineRenderer
  }
}

extension MapViewController: CLLocationManagerDelegate {
  // the function called everytime the user moves
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //Most recent position of our user
    guard let location = locations.last else { return }
    
    /*
    // how zoomed in the map will be
    let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
    let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
    mapView.setRegion(region, animated: true)
    */
    // have the blue dot on the map show to represent the user location
    self.mapView.showsUserLocation = true
  }
}
