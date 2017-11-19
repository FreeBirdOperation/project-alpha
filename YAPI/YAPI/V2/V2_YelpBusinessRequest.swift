//
//  YelpBusinessRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

public final class YelpV2BusinessRequest : Request {
  public typealias ResponseType = YelpV2BusinessResponse
  
  public let host: String = APIEndpoints.Yelp.host
  public let oauthVersion: OAuthSwiftCredential.Version? = .oauth1
  public let path: String
  public let parameters: [String : String]
  public let session: HTTPClient
  public var requestMethod: OAuthSwiftHTTPRequest.Method {
    return .GET
  }
  
  init(businessId: String, locale: YelpV2LocaleParameters? = nil, actionlink: YelpV2ActionlinkParameters? = nil, session: HTTPClient = HTTPClient.sharedSession) {
    var parameters = [String: String]()
    
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
    
    self.path = APIEndpoints.Yelp.V2.business + businessId
    self.parameters = parameters
    self.session = session
  }
}
