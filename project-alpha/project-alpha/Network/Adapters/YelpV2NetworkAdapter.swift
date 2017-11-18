//
//  YelpV2NetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

extension YelpBusiness: BusinessModel {}

final class YelpV2NetworkAdapter: NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void) {
    let searchParams = YelpV2SearchParameters(location: YelpSearchLocation("Portland, OR"))
    let result = APIFactory.Yelp.V2.makeSearchRequest(with: searchParams)
    result.send { result in
      completionHandler(result.map { $0.businesses ?? [] })
    }
  }
  
  
}
