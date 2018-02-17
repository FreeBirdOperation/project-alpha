//
//  YelpV3Request.swift
//  YAPI
//
//  Created by Daniel Seitz on 2/17/18.
//  Copyright © 2018 Daniel Seitz. All rights reserved.
//

import Foundation
import OAuthSwift

protocol YelpV3Request: Request {}

extension YelpV3Request {
  public var oauthVersion: OAuthSwiftCredential.Version? {
    return .oauth2
  }

  public var host: String {
    return APIEndpoints.Yelp.host
  }
}
