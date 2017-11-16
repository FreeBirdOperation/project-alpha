//
//  YelpV3NetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/14/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

extension YelpV3Business: BusinessModel {}

final class YelpV3NetworkAdapter: NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (Result<[BusinessModel], Error>) -> Void) {
    let radius = YelpV3SearchParameters.Radius(params.distance)
    let location = YelpV3LocationParameter(location: "Portland, OR")
    let yelpSearchParams = YelpV3SearchParameters(location: location, radius: radius)
    let request = YelpAPIFactory.V3.makeSearchRequest(with: yelpSearchParams)
    
    request.send { result in
      //                                            \/ This is really dumb...
      completionHandler(result.map { $0.businesses }.mapErr { $0 })
    }
  }
}
