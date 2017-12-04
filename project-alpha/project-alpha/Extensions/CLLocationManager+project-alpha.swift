//
//  CLLocationManager+project-alpha.swift
//  project-alpha
//
//  Created by Cher Moua on 12/3/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation

// TODO: Clean up this interface by hiding Location Manager and Delegate behind our own shared interface
extension CLLocationManager {
  static var sharedInstance: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.delegate = LocationManagerDelegate.sharedInstance
    return locationManager
  }()
}

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
  static let sharedInstance: LocationManagerDelegate = LocationManagerDelegate()
  
  var observers:[CLLocationManagerDelegate] = []

  // the function called everytime the user moves
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for observer in observers{
      observer.locationManager?(manager, didUpdateLocations: locations)
    }
  }
  
  func addObserver(_ observer:CLLocationManagerDelegate){
    guard !observers.contains(where: {$0.isEqual(observer)}) else {return}
    observers.append(observer)
  }
  
  func removeObserver(_ observer:CLLocationManagerDelegate){
    guard let index = observers.index(where: {$0.isEqual(observer)}) else {return}
    observers.remove(at: index)
  }
}
