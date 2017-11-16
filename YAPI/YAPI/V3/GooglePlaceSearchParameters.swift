//
//  GooglePlaceSearchParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/15/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation

public struct GooglePlaceSearchParameters {
  public struct Location: Parameter {
    public let key: String = "location"
    public let coordinate: CLLocationCoordinate2D
    public var latitude: CLLocationDegrees {
      return coordinate.latitude
    }
    public var longitude: CLLocationDegrees {
      return coordinate.longitude
    }
    public var value: String {
      return "\(latitude),\(longitude)"
    }
    
    public init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
      self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public init(coordinate: CLLocationCoordinate2D) {
      self.coordinate = coordinate
    }
  }
  
  public struct Radius: IntParameter {
    public let key: String = "radius"

    let internalValue: Int
    
    public init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  /// The latitude/longitude around which to retrieve place information.
  public let location: Location
  
  /// Defines the distance (in meters) within which to return place results.
  /// The maximum allowed radius is 50 000 meters.
  public let radius: Radius
  
  public init(location: Location,
              radius: Radius) {
    self.location = location
    self.radius = radius
  }
}
