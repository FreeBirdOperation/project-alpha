//
//  YelpV3LookupResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 2/17/18.
//  Copyright © 2018 Daniel Seitz. All rights reserved.
//

import Foundation

public final class YelpV3LookupResponse: Response {
  
  public let business: YelpV3Business

  public let error: APIError?

  public init(withJSON data: [String : AnyObject]) throws {
    if let error = data["error"] as? [String: AnyObject] {
      self.error = YelpV3SearchResponse.parse(error: error)
    }
    else {
      self.error = nil
    }

    do {
      self.business = try YelpV3Business(withDict: data)
    }
    catch {
      if let responseError = self.error {
        throw responseError
      }
      else {
        throw error
      }
    }
  }
}
