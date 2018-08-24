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

private struct GoogleRating: RatingModel {
  var value: Double
}

extension GoogleEstablishment.PriceLevel: PriceModel {
  var value: Double {
    return Double(rawValue)
  }
}

extension GoogleEstablishment: BusinessModel {
  var businessRating: RatingModel {
    return GoogleRating(value: self.rating ?? 0)
  }
  
  var businessPrice: PriceModel? {
    return price_level
  }
  
  var url: URL? {
    return nil
  }
  
  var reviews: [ReviewModel] {
    return []
  }
  
  var imageReferences: [ImageReference] {
    return []
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
  
  var businessCategories: [CategoryModel] {
    // TODO: Implement this
    return []
  }
}

final class GooglePlaceNetworkAdapter: RequestSender, NetworkAdapter {
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
      completionHandler(.err(.apiError(error)))
    case .ok(let request):
      request.send { result in
        completionHandler(result.map { $0.results }.mapErr { .apiError($0) })
      }
    }
  }
  
  func makeLookupRequest(with params: LookupParameters, completionHandler: @escaping (LookupResult) -> Void) {
    // TODO: Implement
    return
  }
  
  func makeReviewRequest(with params: ReviewParameters, completionHandler: @escaping (ReviewResult) -> Void) {
    // TODO: Implement
    return
  }
}
