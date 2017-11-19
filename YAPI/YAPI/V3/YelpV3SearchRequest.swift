//
//  YelpV3SearchRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

public final class YelpV3SearchRequest : Request {
  public typealias ResponseType = YelpV3SearchResponse
 
  public let host: String = APIEndpoints.Yelp.host
  public let oauthVersion: OAuthSwiftCredential.Version? = .oauth2
  public let path: String = APIEndpoints.Yelp.V3.search
  public let parameters: [String : String]
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .GET
  }
  public let session: HTTPClient
  
  init(searchParameters: YelpV3SearchParameters, session: HTTPClient = HTTPClient.sharedSession) {
    var parameters = [String: String]()
    parameters.insert(parameter: searchParameters.term)
    parameters.insert(parameter: searchParameters.location.location)
    parameters.insert(parameter: searchParameters.location.latitude)
    parameters.insert(parameter: searchParameters.location.longitude)
    parameters.insert(parameter: searchParameters.radius)
    parameters.insert(parameter: searchParameters.categories)
    parameters.insert(parameter: searchParameters.locale)
    parameters.insert(parameter: searchParameters.limit)
    parameters.insert(parameter: searchParameters.offset)
    parameters.insert(parameter: searchParameters.sortMode)
    parameters.insert(parameter: searchParameters.price)
    parameters.insert(parameter: searchParameters.openNow)
    parameters.insert(parameter: searchParameters.openAt)
    parameters.insert(parameter: searchParameters.attributes)
    
    self.parameters = parameters
    self.session = session
  }
  
}

