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
  
  public struct Keyword: StringParameter {
    public typealias UnicodeScalarLiteralType = Character
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType

    public let key: String = "keyword"
    
    let internalValue: String

    public init(stringLiteral value: StringLiteralType) {
      self.internalValue = value
    }
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
      self.internalValue = "\(value)"
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
      self.internalValue = value
    }
  }
  
  public enum PlaceType: String, Parameter {
    public var key: String {
      return "type"
    }
    
    public var value: String {
      return self.rawValue
    }
    
    case restaurant = "restaurant"
  }
  
  /// The latitude/longitude around which to retrieve place information.
  public let location: Location
  
  /// Defines the distance (in meters) within which to return place results.
  /// The maximum allowed radius is 50 000 meters.
  public let radius: Radius?
  
  /// A term to be matched against all content that Google has indexed for this
  /// place, including but not limited to name, type, and address, as well as
  /// customer reviews and other third-party content.
  public let keyword: Keyword?
  
  /// Restricts the results to places matching the specified type.
  public let type: PlaceType?
  
  public init(location: Location,
              radius: Radius? = nil,
              keyword: Keyword? = nil,
              type: PlaceType? = nil) {
    self.location = location
    self.radius = radius
    self.keyword = keyword
    self.type = type
  }
}
