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
  
  var businessCategories: [String] {
    return categories.map { $0.categoryName }
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

final class YelpV3NetworkAdapter: RequestSender, NetworkAdapter {
  private var observerList: ObserverList<NetworkObserver> = ObserverList()

  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void) {

    let yelpSearchParams = params.yelpV3SearchParameters()
    
    let request = APIFactory.Yelp.V3.makeSearchRequest(with: yelpSearchParams)
    
    sendRequest(request) { result in
      completionHandler(result.map { $0.businesses })
    }
  }
  
  func makeLookupRequest(with params: LookupParameters, completionHandler: @escaping (LookupResult) -> Void) {
    let yelpLookupParams = YelpV3LookupParameters(id: params.id)
    
    let request = APIFactory.Yelp.V3.makeLookupRequest(with: yelpLookupParams)
    
    sendRequest(request) { result in
      completionHandler(result.map { $0.business })
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
        
    return YelpV3SearchParameters(location: location, radius: radius, locale: locale, limit: limit, offset: offset)
  }
}

private extension PALocale {
  func yelpV3Locale() -> LocaleParameter {
    let language: Language
    switch self.language {
    case .english:
      guard let country = country else {
        language = YelpLocale.English.defaultValue
        break
      }
      let localeString = "\(self.language.rawValue)_\(country)"
      language = YelpLocale.English(rawValue: localeString) ?? YelpLocale.English.defaultValue
    case .spanish:
      guard let country = country else {
        language = YelpLocale.Spanish.defaultValue
        break
      }
      let localeString = "\(self.language.rawValue)_\(country)"
      language = YelpLocale.Spanish(rawValue: localeString) ?? YelpLocale.Spanish.defaultValue
    }
    
    return LocaleParameter(language: language)
  }
}
