//
//  InfoActionHandler.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/19/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

protocol InfoViewControllerDelegate {
  func lookupBusiness(with params: LookupParameters,
                      completionHandler: @escaping (Result<BusinessModel, APIError>) -> Void)
}

private class CacheableBusinessModel: Cacheable {
  let businessModel: BusinessModel
  let isCacheable: Bool = true
  let cacheKey: CacheKey
  init(businessModel: BusinessModel) {
    self.businessModel = businessModel
    self.cacheKey = CacheKey(businessModel.id)
  }
}

class InfoActionHandler: InfoViewControllerDelegate {
  let networkAdapter: NetworkAdapter
  private let lookupResultsCache: Cache<CacheableBusinessModel>
  
  init(networkAdapter: NetworkAdapter) {
    self.networkAdapter = networkAdapter
    self.lookupResultsCache = Cache(identifier: "LookupResultsCache")
  }

  func lookupBusiness(with params: LookupParameters, completionHandler: @escaping (Result<BusinessModel, APIError>) -> Void) {
    
    let cacheKey = CacheKey(params.id)
    if let businessModel = lookupResultsCache[cacheKey] {
      completionHandler(.ok(businessModel.businessModel))
    }
    else {
      networkAdapter.makeLookupRequest(with: params) { [weak self] result in
        if case .ok(let businessModel) = result {
          let cacheableBusinessModel = CacheableBusinessModel(businessModel: businessModel)
          self?.lookupResultsCache.insert(cacheableBusinessModel)
        }
        
        completionHandler(result)
      }
    }
  }
}
