//
//  YelpV3NetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/14/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation
import YAPI

extension YelpV3Business: BusinessModel {
  var imageReferences: [ImageReference] {
    guard !self.photos.isEmpty else {
      if let imageReference = self.image {
        return [imageReference]
      }
      else {
        return []
      }
    }
    
    return self.photos
  }
  
  var coordinate: CLLocationCoordinate2D {
    return self.coordinates.coordinate
  }
  
  var address: AddressModel? {
    return location
  }
}

extension YelpV3Location: AddressModel {
  var street: String {
    return address1
  }
  
  var countryModel: CountryModel {
    return YelpV3CountryModel(name: country, isoCode: nil)
  }
}

private struct YelpV3CountryModel: CountryModel {
  var name: String
  var isoCode: String? = nil
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
  
  func makeLookupRequest(with params: LookupParameters, completionHandler: @escaping (LookupResult) -> Void) {
    let yelpLookupParams = YelpV3LookupParameters(id: params.id)
    
    let request = APIFactory.Yelp.V3.makeLookupRequest(with: yelpLookupParams)
    
    request.send { result in
      completionHandler(result.map { $0.business })
    }
  }
}
