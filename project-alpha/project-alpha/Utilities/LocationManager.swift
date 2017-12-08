//
//  LocationManager.swift
//  project-alpha
//
//  Created by Daniel Seitz on 12/3/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation
import YAPI

protocol LocationManagerProtocol: class {
  var desiredAccuracy: CLLocationAccuracy { get set }
  
  var shouldDisplayHeadingCalibration: Bool { get set }
  
  func requestWhenInUseAuthorization()
  func startUpdatingLocation()
  
  /**
   Add a delegate observer, whenever a CLLocationManager event occurs any observers will
   have their corresponding delegate functions called with the appropriate arguments.
   
   It is safe to add an observer multiple times, the delegate functions will still only
   be called once for each unique delegate instance.
   */
  func addObserver(_ observer: CLLocationManagerDelegate)
  
  /**
   Remove a delegate observer
   */
  func removeObserver(_ observer: CLLocationManagerDelegate)
}

class LocationManager {
  private let locationManager: CLLocationManager
  private let locationManagerDelegate: LocationManagerDelegate

  static let sharedManager: LocationManager = LocationManager()
  
  init(locationManager: CLLocationManager = CLLocationManager()) {
    self.locationManager = locationManager
    self.locationManagerDelegate = LocationManagerDelegate()
    
    self.locationManager.delegate = self.locationManagerDelegate
  }
  
  func contains(observer: CLLocationManagerDelegate) -> Bool {
    return locationManagerDelegate.contains(observer: observer)
  }
}

extension LocationManager: LocationManagerProtocol {
  var desiredAccuracy: CLLocationAccuracy {
    get {
      return locationManager.desiredAccuracy
    }
    
    set {
      locationManager.desiredAccuracy = newValue
    }
  }
  
  var shouldDisplayHeadingCalibration: Bool {
    get {
      return locationManagerDelegate.shouldDisplayHeadingCalibration
    }
    
    set {
      locationManagerDelegate.shouldDisplayHeadingCalibration = newValue
    }
  }
  
  func requestWhenInUseAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }

  func addObserver(_ observer: CLLocationManagerDelegate) {
    locationManagerDelegate.addObserver(observer)
  }
  
  func removeObserver(_ observer: CLLocationManagerDelegate) {
    locationManagerDelegate.removeObserver(observer)
  }
}

// MARK: LocationManagerDelegate Implementation
private class LocationManagerDelegate: NSObject {
  private var _observers: [Weak<CLLocationManagerDelegate>] = []
  private var observers: [CLLocationManagerDelegate] {
      return _observers.flatMap { $0.value }
  }
  
  fileprivate var shouldDisplayHeadingCalibration: Bool = false
  
  fileprivate func contains(observer: CLLocationManagerDelegate) -> Bool {
    return _observers.flatMap { $0.value }.contains { $0.isEqual(observer) }
  }
  
  fileprivate func addObserver(_ observer: CLLocationManagerDelegate) {
    assert(Thread.isMainThread, "Only add yourself as a location observer on the main thread")
    
    // Compact the array if any of our delegates have been deallocated
    var newArray = _observers.flatMap { $0.value }
    defer {
      _observers = newArray.map { Weak($0) }
    }
    
    guard !newArray.contains(where: { $0.isEqual(observer) }) else { return }
    newArray.append(observer)
  }

  fileprivate func removeObserver(_ observer: CLLocationManagerDelegate) {
    assert(Thread.isMainThread, "Only remove yourself as a location observer on the main thread")
    
    // Compact the array if any of our delegates have been deallocated
    var newArray = _observers.flatMap { $0.value }
    defer {
      _observers = newArray.map { Weak($0) }
    }

    guard let index = newArray.index(where: { $0.isEqual(observer) }) else { return }
    newArray.remove(at: index)
  }
}

extension LocationManagerDelegate: CLLocationManagerDelegate {
  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    return shouldDisplayHeadingCalibration
  }

  func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    observers.forEach { $0.locationManagerDidPauseLocationUpdates?(manager) }
  }
  
  func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
    observers.forEach { $0.locationManagerDidResumeLocationUpdates?(manager) }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
    observers.forEach {
      $0.locationManager?(manager,
                          didUpdateLocations: locations)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didVisit visit: CLVisit) {
    
    observers.forEach {
      $0.locationManager?(manager,
                          didVisit: visit)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didFailWithError error: Error) {
    observers.forEach {
      $0.locationManager?(manager,
                          didFailWithError: error)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didExitRegion region: CLRegion) {
    observers.forEach {
      $0.locationManager?(manager,
                          didExitRegion: region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didEnterRegion region: CLRegion) {
    observers.forEach {
      $0.locationManager?(manager,
                          didEnterRegion: region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didStartMonitoringFor region: CLRegion) {
    observers.forEach {
      $0.locationManager?(manager,
                          didStartMonitoringFor: region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didUpdateHeading newHeading: CLHeading) {
    observers.forEach {
      $0.locationManager?(manager,
                          didUpdateHeading: newHeading)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didFinishDeferredUpdatesWithError error: Error?) {
    observers.forEach {
      $0.locationManager?(manager,
                          didFinishDeferredUpdatesWithError: error)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
    observers.forEach {
      $0.locationManager?(manager,
                          didChangeAuthorization: status)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didDetermineState state: CLRegionState,
                       for region: CLRegion) {
    observers.forEach {
      $0.locationManager?(manager,
                          didDetermineState: state,
                          for: region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       didRangeBeacons beacons: [CLBeacon],
                       in region: CLBeaconRegion) {
    observers.forEach {
      $0.locationManager?(manager,
                          didRangeBeacons: beacons,
                          in: region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       monitoringDidFailFor region: CLRegion?,
                       withError error: Error) {
    observers.forEach {
      $0.locationManager?(manager,
                          monitoringDidFailFor: region,
                          withError: error)
    }
  }
  
  func locationManager(_ manager: CLLocationManager,
                       rangingBeaconsDidFailFor region: CLBeaconRegion,
                       withError error: Error) {
    observers.forEach {
      $0.locationManager?(manager,
                          rangingBeaconsDidFailFor: region,
                          withError: error)
    }
  }
}
