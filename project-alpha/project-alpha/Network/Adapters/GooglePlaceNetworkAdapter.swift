//
//  GooglePlaceNetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation
import YAPI

extension GoogleEstablishment: BusinessModel {
  var imageReference: ImageReference? {
    return nil
  }
  
  var id: String {
    return ""
  }
  
  var coordinate: CLLocationCoordinate2D {
    let latitude = geometry.location.lat
    let longitude = geometry.location.lng
    
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  var address: AddressModel? {
    return nil
  }
}

final class GooglePlaceNetworkAdapter: NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void) {
    let locationParam = GooglePlaceSearchParameters.Location(latitude: 45.509761, longitude: -122.679809)
    let radiusParam = GooglePlaceSearchParameters.Radius(params.distance)
    let keywordParam = GooglePlaceSearchParameters.Keyword("drinks")
    let typeParam = GooglePlaceSearchParameters.PlaceType.restaurant
    let searchParams = GooglePlaceSearchParameters(location: locationParam,
                                                   radius: radiusParam,
                                                   keyword: keywordParam,
                                                   type: typeParam)
    
    let result = APIFactory.Google.makeSearchRequest(with: searchParams)
    
    switch result {
    case .err(let error):
      completionHandler(.err(error))
    case .ok(let request):
      request.send { result in
        completionHandler(result.map { $0.results })
      }
    }
  }
}
