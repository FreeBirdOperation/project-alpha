//
//  YelpV2NetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation
import YAPI

extension YelpBusiness: BusinessModel {
  var imageReferences: [ImageReference] {
    return []
  }
  
  var coordinate: CLLocationCoordinate2D {
    // FIXME: Come back and find a safe way to get these coordinates
    let latitude = location.coordinate!.latitude
    let longitude = location.coordinate!.longitude
    
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  
  var address: AddressModel? {
    // TODO: Implement this, we should have the required information
    return nil
  }
}

final class YelpV2NetworkAdapter: NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void) {
    let searchParams = YelpV2SearchParameters(location: YelpSearchLocation("Portland, OR"))
    let result = APIFactory.Yelp.V2.makeSearchRequest(with: searchParams)
    result.send { result in
      completionHandler(result.map { $0.businesses ?? [] })
    }
  }
  
  func makeLookupRequest(with params: LookupParameters, completionHandler: @escaping (LookupResult) -> Void) {
    // TODO: Implement
    return
  }
}
