//
//  YelpV3TokenRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

/**
    A YelpRequest that is used in order to retrieve an access token for the Yelp API.
 */
public final class YelpV3TokenRequest : Request {
  public typealias ResponseType = YelpV3TokenResponse
  
  public let oauthVersion: OAuthSwiftCredential.Version = .oauth2
  public let path: String = YelpEndpoints.V3.token
  public let parameters: [String: String]
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .POST
  }
  public let session: YelpHTTPClient
  
  init(token: YelpV3TokenParameters, session: YelpHTTPClient = YelpHTTPClient.sharedSession) {
    var parameters = [String: String]()
    parameters.insert(parameter: token.grantType)
    parameters.insert(parameter: token.clientId)
    parameters.insert(parameter: token.clientSecret)
    
    self.parameters = parameters
    self.session = session
  }
}
