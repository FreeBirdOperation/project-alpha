//
//  YelpCoordinate.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/11/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation

public struct YelpCoordinate {
  private enum Params {
    static let latitude = "latitude"
    static let longitude = "longitude"
  }
  public let coordinate: CLLocationCoordinate2D
  public var latitude: CLLocationDegrees {
    return coordinate.latitude
  }
  public var longitude: CLLocationDegrees {
    return coordinate.longitude
  }
  
  public init(withDict dict: [String: AnyObject]) throws {
    let latitude: CLLocationDegrees = try dict.parseParam(key: Params.latitude)
    let longitude: CLLocationDegrees = try dict.parseParam(key: Params.longitude)
    
    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
