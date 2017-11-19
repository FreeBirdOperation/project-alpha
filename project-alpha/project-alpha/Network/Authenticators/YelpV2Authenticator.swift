//
//  YelpV2Authenticator.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

struct YelpV2AuthenticationToken {
  let consumerKey: String
  let consumerSecret: String
  let token: String
  let tokenSecret: String
}

final class YelpV2Authenticator: Authenticator {
  typealias TokenType = YelpV2AuthenticationToken

  static func authenticate(with token: YelpV2AuthenticationToken, completionHandler: @escaping (Result<NetworkAdapter, Error>) -> Void) {
    APIFactory.Yelp.V2.setAuthenticationKeys(consumerKey: token.consumerKey, consumerSecret: token.consumerSecret, token: token.token, tokenSecret: token.tokenSecret)
    completionHandler(.ok(YelpV2NetworkAdapter()))
  }
}
