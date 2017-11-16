//
//  YelpV2NetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

final class YelpV2NetworkAdapter: NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (Result<[BusinessModel], Error>) -> Void) {
    let searchParams = YelpV2SearchParameters(location: YelpSearchLocation("Portland, OR"))
    let result = APIFactory.Yelp.V2.makeSearchRequest(with: searchParams)
    result.send { result in
      
    }
  }
  
  
}
