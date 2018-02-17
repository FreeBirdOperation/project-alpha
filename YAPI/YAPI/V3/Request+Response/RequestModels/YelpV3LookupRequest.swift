//
//  YelpV3LookupRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 2/17/18.
//  Copyright © 2018 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

public final class YelpV3LookupRequest: YelpV3Request {
  public typealias ResponseType = YelpV3LookupResponse

  public var path: String {
    return "\(APIEndpoints.Yelp.V3.lookup)/\(id)"
  }
  public let parameters: [String : String]
  public let requestMethod: OAuthSwiftHTTPRequest.Method = .GET
  public let session: HTTPClient
  
  private let id: String
  
  init(parameters: YelpV3LookupParameters, session: HTTPClient = HTTPClient.sharedSession) {
    var params = [String: String]()
    self.id = parameters.id
    
    params.insert(parameter: parameters.locale)
    
    self.parameters = params
    self.session = session
  }
}
