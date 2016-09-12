//
//  YelpSearchResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public final class YelpSearchResponse : YelpResponse {
  public let request: YelpRequest
  public let region: YelpRegion?
  public let total: Int?
  public let businesses: [YelpBusiness]?
  public let error: YelpResponseError?
  
  init(withJSON data: [String: AnyObject], from request: YelpRequest) {
    if let error = data["error"] as? [String: AnyObject] {
      switch error["id"] as! String {
      case "INTERNAL_ERROR":
        self.error = YelpResponseError.InternalError
      case "EXCEEDED_REQS":
        self.error = YelpResponseError.ExceededRequests
      case "MISSING_PARAMETER":
        self.error = YelpResponseError.MissingParameter(field: error["field"] as! String)
      case "INVALID_PARAMETER":
        self.error = YelpResponseError.InvalidParameter(field: error["field"] as! String)
      case "UNAVAILABLE_FOR_LOCATION":
        self.error = YelpResponseError.UnavailableForLocation
      case "AREA_TOO_LARGE":
        self.error = YelpResponseError.AreaTooLarge
      case "MULTIPLE_LOCATIONS":
        self.error = YelpResponseError.MultipleLocations
      case "BUSINESS_UNAVAILABLE":
        self.error = YelpResponseError.BusinessUnavailable
      default:
        self.error = YelpResponseError.UnknownError
      }
    }
    else {
      self.error = nil
    }
    
    if self.error == nil {
      if let regionDict = data["region"] as? [String: AnyObject] {
        self.region = YelpRegion(withDict: regionDict)
      }
      else {
        self.region = nil
      }
      
      if let total = data["total"] as? Int {
        self.total = total
      }
      else {
        self.total = nil
      }
      
      var businesses = [YelpBusiness]()
      for business in data["businesses"] as! [[String: AnyObject]] {
        let yelpBusiness = YelpBusiness(withDict: business)
        businesses.append(yelpBusiness)
      }
      self.businesses = businesses
    }
    else {
      self.region = nil
      self.total = nil
      self.businesses = nil
    }
    self.request = request
  }
}
