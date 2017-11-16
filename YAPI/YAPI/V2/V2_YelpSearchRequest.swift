//
//  YelpSearchRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift
import CoreLocation

/**
    A Request that queries the Yelp API's search service. This gives a list of businesses based on 
    certain parameters like category, type, distance, search location, etc. The number of businesses 
    returned can be limited as well in the parameters. This class is meant to be one-shot, if you want to 
    send another request create a new instance of this class. The query parameters can only be set in the 
    initializer. Instances of this class should be created through the APIFactory.
 */
public final class YelpV2SearchRequest: Request {
  
  public typealias ResponseType = YelpV2SearchResponse
  
  public let host: String = APIEndpoints.Yelp.host
  public let oauthVersion: OAuthSwiftCredential.Version = .oauth1
  public let path: String = APIEndpoints.Yelp.V2.search
  public let parameters: [String: String]
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .GET
  }
  public let session: HTTPClient
  
  init(search: YelpV2SearchParameters, locale: YelpV2LocaleParameters? = nil, actionlink: YelpV2ActionlinkParameters? = nil, session: HTTPClient = HTTPClient.sharedSession) {
    var parameters = [String: String]()
    
    // Search Parameters
    parameters.insert(parameter: search.location)
    if let hint = (search.location as? InternalLocation)?.hint {
      parameters.insert(parameter: hint)
    }
    if let limit = search.limit {
      parameters.insert(parameter: limit)
    }
    if let term = search.term {
      parameters.insert(parameter: term)
    }
    if let offset = search.offset {
      parameters.insert(parameter: offset)
    }
    if let sortMode = search.sortMode {
      parameters.insert(parameter: sortMode)
    }
    if let categories = search.categories {
      parameters.insert(parameter: categories)
    }
    if let radius = search.radius {
      parameters.insert(parameter: radius)
    }
    if let filterDeals = search.filterDeals {
      parameters.insert(parameter: filterDeals)
    }
    
    // Locale Parameters
    if let locale = locale {
      if let countryCode = locale.countryCode {
        parameters.insert(parameter: countryCode)
      }
      if let language = locale.language {
        parameters.insert(parameter: language)
      }
      if let filterLanguage = locale.filterLanguage {
        parameters.insert(parameter: filterLanguage)
      }
    }
    
    // Actionlink Parameters
    if let actionlink = actionlink {
      if let actionlinks = actionlink.actionlinks {
        parameters.insert(parameter: actionlinks)
      }
    }
    
    self.parameters = parameters
    self.session = session
  }
}
