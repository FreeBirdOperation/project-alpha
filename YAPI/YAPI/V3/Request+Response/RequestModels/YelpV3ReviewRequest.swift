//
//  YelpV3ReviewRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 5/26/18.
//  Copyright © 2018 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

public final class YelpV3ReviewRequest: YelpV3Request {
  public typealias ResponseType = YelpV3ReviewResponse

  lazy public var path: String = APIEndpoints.Yelp.V3.review(id)
  public let parameters: [String : String]
  public let requestMethod: OAuthSwiftHTTPRequest.Method = .GET
  public var session: HTTPClient
  
  private let id: String
  
  init(parameters: YelpV3ReviewParameters, session: HTTPClient = HTTPClient.sharedSession) {
    var params = [String: String]()
    self.id = parameters.id
    
    params.insert(parameter: parameters.locale)
    
    self.parameters = params
    self.session = session
  }
}
