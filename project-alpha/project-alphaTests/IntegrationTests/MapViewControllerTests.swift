//
//  MapViewControllerTests.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/3/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import XCTest
import CoreLocation

@testable import project_alpha

class MapViewControllerTests: ViewControllerIntegrationTestCase {
  private var mockLocationManager: MockLocationManager = Mock.locationManager

  override func setUp() {
    mockLocationManager = Mock.locationManager
    viewController = MapViewController(locationManger: mockLocationManager)
    
    super.setUp()
  }
  
  func test_ViewController_StartsLocationManager_WithBestAccuracy_AndAddsSelfAsObserver() {
    XCTAssertTrue(mockLocationManager.didStartUpdatingLocation)
    XCTAssertEqual(mockLocationManager.desiredAccuracy, kCLLocationAccuracyBest)
    XCTAssertTrue(mockLocationManager.contains(observer: viewController))
  }
}
