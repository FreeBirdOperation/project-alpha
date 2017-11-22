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
    return nil
  }
}

final class YelpV3NetworkAdapter: NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void) {
    let radius = YelpV3SearchParameters.Radius(params.distance)
    let location = YelpV3LocationParameter(location: "Portland, OR")
    let yelpSearchParams = YelpV3SearchParameters(location: location, radius: radius)
    let request = APIFactory.Yelp.V3.makeSearchRequest(with: yelpSearchParams)
    
    request.send { result in
      completionHandler(result.map { $0.businesses })
    }
  }
}
