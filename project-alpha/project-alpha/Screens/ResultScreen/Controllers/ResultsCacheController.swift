//
//  ResultsCacheController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 8/19/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

private class Result: Cacheable {
  let businessID: String
  
  var isCacheable: Bool {
    return true
  }
  
  var cacheKey: CacheKey {
    return CacheKey(businessID)
  }
  
  init(businessID: String) {
    self.businessID = businessID
  }
}

class ResultsCacheController {
  private static let resultsCache: Cache<Result> = Cache(identifier: "results-cache")
  
  static func contains(businessID: String) -> Bool {
    return resultsCache.contains(Result(businessID: businessID))
  }
  
  static func add(businessIDs: [String]) {
    for businessID in businessIDs {
      add(businessID: businessID)
    }
  }
  
  static func add(businessID: String) {
    resultsCache.insert(Result(businessID: businessID))
  }
}
