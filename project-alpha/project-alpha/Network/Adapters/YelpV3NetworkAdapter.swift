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

private struct YelpRating: RatingModel {
  var value: Double
}

extension YelpPrice: PriceModel {
  var value: Double {
    return Double(rawValue)
  }
}

extension YelpV2Category: CategoryModel {
  var name: String {
    return alias
  }
  
  var displayName: String {
    return categoryName
  }
}

extension YelpV3Business: BusinessModel {
  var businessRating: RatingModel {
    return YelpRating(value: rating)
  }
  
  var businessPrice: PriceModel? {
    return price
  }
  
  var reviews: [ReviewModel] {
    return []
  }
  
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
  
  var businessCategories: [CategoryModel] {
    return categories
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

extension YelpReview: ReviewModel {
  var userImage: ImageReference? {
    return user.image
  }
  
  var userName: String {
    return user.name
  }
}

final class YelpV3NetworkAdapter: RequestSender, NetworkAdapter {
  private var observerList: ObserverList<NetworkObserver> = ObserverList()

  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void) {

    let yelpSearchParams = params.yelpV3SearchParameters()
    
    let request = APIFactory.Yelp.V3.makeSearchRequest(with: yelpSearchParams)
    
    sendRequest(request) { result in
      completionHandler(result.map { $0.businesses }.mapErr { .apiError($0) })
    }
  }
  
  func makeLookupRequest(with params: LookupParameters, completionHandler: @escaping (LookupResult) -> Void) {
    let yelpLookupParams = YelpV3LookupParameters(id: params.id)
    
    let request = APIFactory.Yelp.V3.makeLookupRequest(with: yelpLookupParams)
    
    sendRequest(request) { result in
      completionHandler(result.map { $0.business })
    }
  }
  
  func makeReviewRequest(with params: ReviewParameters, completionHandler: @escaping (ReviewResult) -> Void) {
    let yelpReviewParams = YelpV3ReviewParameters(id: params.id,
                                                  locale: params.locale?.yelpV3Locale())
    
    let request = APIFactory.Yelp.V3.makeReviewRequest(with: yelpReviewParams)
    
    sendRequest(request) { result in
      completionHandler(result.map { $0.reviews })
    }
  }
}

private extension SearchParameters {
  func yelpV3SearchParameters() -> YelpV3SearchParameters {
    let location = YelpV3LocationParameter(coreLocation: self.location)
    let radius = YelpV3SearchParameters.Radius(self.distance)
    let offset = YelpV3SearchParameters.Offset(self.offset)
    let limit = YelpV3SearchParameters.Limit(self.limit)
    let locale = self.locale?.yelpV3Locale()
        
    return YelpV3SearchParameters(location: location,
                                  radius: radius,
                                  locale: locale,
                                  limit: limit,
                                  offset: offset,
                                  openNow: true)
  }
}

private extension PALocale {
  func yelpV3Locale() -> LocaleParameter {
    switch language {
    case .english:
      let language: YelpLocale.English = yelpLanguage(for: self.language)
      return LocaleParameter(language: language)
    case .spanish:
      let language: YelpLocale.Spanish = yelpLanguage(for: self.language)
      return LocaleParameter(language: language)
    }
  }
  
  private func yelpLanguage<T: YelpLocaleProtocol>(for language: PALanguage) -> T {
    guard let country = country else {
      return T.defaultValue
    }

    let localeString = "\(language.rawValue)_\(country)"
    return T.init(rawValue: localeString) ?? T.defaultValue
  }
}
