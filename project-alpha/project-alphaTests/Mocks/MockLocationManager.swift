//
//  MockLocationManager.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/3/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation

@testable import project_alpha

extension Mock {
  static var locationManager: LocationManager { return LocationManager() }

  class LocationManager {
    private(set) var didRequestAuthorization: Bool = false
    private(set) var didStartUpdatingLocation: Bool = false
    private(set) var observers: [CLLocationManagerDelegate] = []
    
    // LocationManagerProtocol conformance
    var desiredAccuracy: CLLocationAccuracy = Double.nan // An invalid value for testing purposes
    var shouldDisplayHeadingCalibration: Bool = false
    
    fileprivate init() {}
    
    func contains(observer: NSObject) -> Bool {
      return observers.contains { $0.isEqual(observer) }
    }
  }
}

extension Mock.LocationManager: LocationManagerProtocol {
  func requestWhenInUseAuthorization() {
    didRequestAuthorization = true
  }
  
  func startUpdatingLocation() {
    didStartUpdatingLocation = true
  }
  
  func addObserver(_ observer: CLLocationManagerDelegate) {
    observers.append(observer)
  }
  
  func removeObserver(_ observer: CLLocationManagerDelegate) {
    guard let index = observers.index(where: { $0.isEqual(observer) }) else { return }
    observers.remove(at: index)
  }
}
