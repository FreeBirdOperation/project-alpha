//
//  YelpV3Authenticator.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/14/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

struct YelpV3AuthenticationToken {
  let appId: String
  let clientSecret: String
}

final class YelpV3Authenticator: Authenticator {
  typealias TokenType = YelpV3AuthenticationToken
  
  class func authenticate(with token: YelpV3AuthenticationToken, completionHandler: @escaping (Result<NetworkAdapter, Error>) -> Void) {
    YelpAPIFactory.V3.authenticate(appId: token.appId, clientSecret: token.clientSecret) { error in
      let result: Result<NetworkAdapter, Error>
      if let error = error {
        result = .err(error)
      }
      else {
        result = .ok(YelpV3NetworkAdapter())
      }
      
      completionHandler(result)
    }
  }
}
