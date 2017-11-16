//
//  YelpPhoneSearchRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/12/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

public final class YelpV2PhoneSearchRequest : Request {
  public typealias ResponseType = YelpV2PhoneSearchResponse

  public let oauthVersion: OAuthSwiftCredential.Version = .oauth1
  public let path: String = YelpEndpoints.V2.phone
  public let parameters: [String: String]
  public let session: YelpHTTPClient
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .GET
  }
  
  init(phoneSearch: YelpV2PhoneSearchParameters, session: YelpHTTPClient = YelpHTTPClient.sharedSession) {
    var parameters = [String: String]()
    
    parameters.insert(parameter: phoneSearch.phone)
    if let countryCode = phoneSearch.countryCode {
      parameters.insert(parameter: countryCode)
    }
    if let category = phoneSearch.category {
      parameters.insert(parameter: category)
    }
    self.parameters = parameters
    self.session = session
  }
}
