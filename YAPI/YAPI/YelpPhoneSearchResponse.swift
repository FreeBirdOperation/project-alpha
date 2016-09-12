//
//  YelpPhoneSearchResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/12/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public final class YelpPhoneSearchResponse : YelpResponse {
  public let request: YelpRequest
  public let region: YelpRegion?
  public let total: Int?
  public let businesses: [YelpBusiness]?
  public let error: YelpResponseError?
  
  init(withJSON data: [String: AnyObject], from request: YelpRequest) {
    if let error = data["error"] as? [String: AnyObject] {
      self.error = self.dynamicType.parseError(errorDict: error)
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