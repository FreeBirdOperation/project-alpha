//
//  GooglePlaceAuthenticator.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

struct GooglePlaceAuthenticationToken {
  let token: String
}

final class GooglePlaceAuthenticator: Authenticator {
  typealias TokenType = GooglePlaceAuthenticationToken

  static func authenticate(with token: GooglePlaceAuthenticationToken, completionHandler: @escaping (Result<NetworkAdapter, Error>) -> Void) {
    APIFactory.Google.setAppToken(token.token)
    completionHandler(.ok(GooglePlaceNetworkAdapter()))
  }
}
