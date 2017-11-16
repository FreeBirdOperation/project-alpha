//
//  GooglePlaceSearchRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/15/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

public final class GooglePlaceSearchRequest: GoogleRequest {
  public typealias ResponseType = GooglePlaceSearchResponse

  public let oauthVersion: OAuthSwiftCredential.Version? = nil
  public let path: String = APIEndpoints.Google.search
  public let requestMethod: OAuthSwiftHTTPRequest.Method = .GET
  
  public let parameters: [String: String]
  public let session: HTTPClient
  
  init(with params: GooglePlaceSearchParameters, token: GoogleAuthToken, session: HTTPClient = HTTPClient.sharedSession) {
    var parameters = [String: String]()
    parameters["key"] = token.token
    parameters.insert(parameter: params.location)
    parameters.insert(parameter: params.radius)
    
    self.parameters = parameters
    self.session = session
  }
}
