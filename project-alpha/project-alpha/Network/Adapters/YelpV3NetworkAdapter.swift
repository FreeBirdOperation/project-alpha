//
//  YelpV3NetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/14/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

extension YelpV3Business: BusinessModel {
  var imageReference: ImageReference? {
    return self.image
  }
}

final class YelpV3NetworkAdapter: NetworkAdapter {
  // TESTING: Get the next chunk of restauraunts for the next request
  var offset: Int = 0

  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void) {
    let radius = YelpV3SearchParameters.Radius(params.distance)
    let location = YelpV3LocationParameter(location: "Portland, OR")

    // TESTING: Get the next chunk of restauraunts for the next request
    let offset = YelpV3SearchParameters.Offset(self.offset)
    let yelpSearchParams = YelpV3SearchParameters(location: location, radius: radius, offset: offset)
    let request = APIFactory.Yelp.V3.makeSearchRequest(with: yelpSearchParams)
    
    // TESTING: Get the next chunk of restauraunts for the next request
    self.offset += 20
    
    request.send { result in
      completionHandler(result.map { $0.businesses })
    }
  }
}
