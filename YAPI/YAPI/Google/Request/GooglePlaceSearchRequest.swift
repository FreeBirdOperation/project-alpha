//
//  GooglePlaceSearchRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/15/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

final class GooglePlaceSearchRequest: GoogleRequest {
  typealias ResponseType = GooglePlaceSearchResponse

  let oauthVersion: OAuthSwiftCredential.Version = .oauth1
  let path: String = APIEndpoints.Google.search
  let requestMethod: OAuthSwiftHTTPRequest.Method = .GET
  
  let parameters: [String: String]
  let session: HTTPClient
  
  init(with parameters: GooglePlaceSearchParameters, session: HTTPClient = HTTPClient.sharedSession) {
    var parameters = [String: String]()
    
    self.parameters = parameters
    self.session = session
  }
}
