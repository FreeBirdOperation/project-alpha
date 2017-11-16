//
//  GooglePlaceNetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

final class GooglePlaceNetworkAdapter: NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (Result<[BusinessModel], Error>) -> Void) {
    let locationParam = GooglePlaceSearchParameters.Location(latitude: 45.509761, longitude: -122.679809)
    let radiusParam = GooglePlaceSearchParameters.Radius(params.distance)
    let searchParams = GooglePlaceSearchParameters(location: locationParam, radius: radiusParam)
    
    let result = APIFactory.Google.makeSearchRequest(with: searchParams)
    
    switch result {
    case .err(let error):
      completionHandler(.err(error))
    case .ok(let request):
      request.send { result in
        print(result)
      }
    }
  }
}
