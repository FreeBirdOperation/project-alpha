//
//  LocationManagerTests.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/3/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation
import XCTest

@testable import project_alpha

private class MockCLLocationManager: CLLocationManager {
  private(set) var didRequestAuthorization: Bool = false
  private(set) var didStartUpdatingLocation: Bool = false

  override func requestWhenInUseAuthorization() {
    didRequestAuthorization = true
  }

  override func startUpdatingLocation() {
    didStartUpdatingLocation = true
  }
}

private class MockCLLocationManagerDelegate: NSObject, CLLocationManagerDelegate {
  private(set) var didPauseLocationUpdates: Bool = false
  func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    didPauseLocationUpdates = true
  }
  
  private(set) var didResumeLocationUpdates: Bool = false
  func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
    didResumeLocationUpdates = true
  }
  
  private(set) var didVisit: Bool = false
  func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    didVisit = true
  }
  
  private(set) var didFailWithError: Bool = false
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    didFailWithError = true
  }
  
  private(set) var didExitRegion: Bool = false
  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    didExitRegion = true
  }
  
  private(set) var didEnterRegion: Bool = false
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    didEnterRegion = true
  }
  
  private(set) var didStartMonitoring: Bool = false
  func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
    didStartMonitoring = true
  }
  
  private(set) var didUpdateHeading: Bool = false
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    didUpdateHeading = true
  }
  
  private(set) var didUpdateLocations: Bool = false
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    didUpdateLocations = true
  }
  
  private(set) var didFinishedDefferedUpdatesWithError: Bool = false
  func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
    didFinishedDefferedUpdatesWithError = true
  }
  
  private(set) var didChangeAuthorization: Bool = false
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    didChangeAuthorization = true
  }
  
  private(set) var didDetermineState: Bool = false
  func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
    didDetermineState = true
  }
  
  private(set) var didRangeBeacons: Bool = false
  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    didRangeBeacons = true
  }
  
  private(set) var monitoringDidFail: Bool = false
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    monitoringDidFail = true
  }
  
  private(set) var rangingBeaconsDidFail: Bool = false
  func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
    rangingBeaconsDidFail = true
  }
}

class LocationManagerTests: PAXCTestCase {
  var locationManager: LocationManager!
  fileprivate var mockLocationManager: MockCLLocationManager!
  
  override func setUp() {
    mockLocationManager = MockCLLocationManager()
    locationManager = LocationManager(locationManager: mockLocationManager)
  }
  
  func test_LocationManager_PassesCallsThroughToInternalManager() {
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    XCTAssertTrue(mockLocationManager.didRequestAuthorization)
    XCTAssertTrue(mockLocationManager.didStartUpdatingLocation)
  }
  
  func test_LocationManager_AddObserver_AddsToObserverArray() {
    let mockObserver = MockCLLocationManagerDelegate()
    
    locationManager.addObserver(mockObserver)
    
    XCTAssertTrue(locationManager.contains(observer: mockObserver))
  }
  
  func test_LocationManager_RemoveObserver_RemovesTheObserver() {
    let mockObserver = MockCLLocationManagerDelegate()
    
    locationManager.addObserver(mockObserver)
    
    XCTAssertTrue(locationManager.contains(observer: mockObserver))
    
    locationManager.removeObserver(mockObserver)
    
    XCTAssertFalse(locationManager.contains(observer: mockObserver))
  }
  
  func test_LocationManager_RemoveObserver_WhenNotObserving_DoesNothing() {
    let mockObserver = MockCLLocationManagerDelegate()
    
    XCTAssertFalse(locationManager.contains(observer: mockObserver))

    locationManager.removeObserver(mockObserver)

    XCTAssertFalse(locationManager.contains(observer: mockObserver))
  }
  
  func test_LocationManager_DesiredAccuracy_PassesThroughToInternalLocationManager() {
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    XCTAssertEqual(mockLocationManager.desiredAccuracy, kCLLocationAccuracyBest)
    
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    
    XCTAssertEqual(mockLocationManager.desiredAccuracy, kCLLocationAccuracyKilometer)
  }
  
  func test_LocationManager_ShouldDisplayHeadingCalibration_PassesThroughDelegate() {
    locationManager.shouldDisplayHeadingCalibration = false

    guard let result = mockLocationManager.delegate?.locationManagerShouldDisplayHeadingCalibration?(mockLocationManager) else {
      return XCTFail("Failed to get a boolean result from delegate")
    }
    XCTAssertFalse(result)
    
    locationManager.shouldDisplayHeadingCalibration = true
    
    guard let result2 = mockLocationManager.delegate?.locationManagerShouldDisplayHeadingCalibration?(mockLocationManager) else {
      return XCTFail("Failed to get a boolean result from delegate")
    }
    XCTAssertTrue(result2)
  }
  
  func test_LocationManager_DelegatePassesCallsToObservers() {
    let mockObserver = MockCLLocationManagerDelegate()
    
    locationManager.addObserver(mockObserver)
    
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didVisit: CLVisit())
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didExitRegion: CLRegion())
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didEnterRegion: CLRegion())
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didFailWithError: Mock.error)
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didUpdateHeading: CLHeading())
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didRangeBeacons: [], in: CLBeaconRegion(proximityUUID: UUID(), identifier: "mock"))
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didUpdateLocations: [])
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didDetermineState: .unknown, for: CLRegion())
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didStartMonitoringFor: CLRegion())
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didChangeAuthorization: .notDetermined)
    mockLocationManager.delegate?.locationManagerDidPauseLocationUpdates?(mockLocationManager)
    mockLocationManager.delegate?.locationManagerDidResumeLocationUpdates?(mockLocationManager)
    mockLocationManager.delegate?.locationManager?(mockLocationManager, monitoringDidFailFor: nil, withError: Mock.error)
    mockLocationManager.delegate?.locationManager?(mockLocationManager, didFinishDeferredUpdatesWithError: nil)
    mockLocationManager.delegate?.locationManager?(mockLocationManager, rangingBeaconsDidFailFor: CLBeaconRegion(proximityUUID: UUID(), identifier: "mock"), withError: Mock.error)
    
    XCTAssertTrue(mockObserver.didVisit)
    XCTAssertTrue(mockObserver.didExitRegion)
    XCTAssertTrue(mockObserver.didEnterRegion)
    XCTAssertTrue(mockObserver.didFailWithError)
    XCTAssertTrue(mockObserver.didUpdateHeading)
    XCTAssertTrue(mockObserver.didRangeBeacons)
    XCTAssertTrue(mockObserver.didUpdateLocations)
    XCTAssertTrue(mockObserver.didDetermineState)
    XCTAssertTrue(mockObserver.didStartMonitoring)
    XCTAssertTrue(mockObserver.didChangeAuthorization)
    XCTAssertTrue(mockObserver.didPauseLocationUpdates)
    XCTAssertTrue(mockObserver.didResumeLocationUpdates)
    XCTAssertTrue(mockObserver.monitoringDidFail)
    XCTAssertTrue(mockObserver.didFinishedDefferedUpdatesWithError)
    XCTAssertTrue(mockObserver.rangingBeaconsDidFail)
  }
}
