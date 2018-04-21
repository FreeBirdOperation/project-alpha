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
  let apiKey: String
  
  static var token: YelpV3AuthenticationToken! {
    let keys = getKeys()
    guard let apiKey = keys["API_KEY"] else {
        assertionFailure("Unable to retrieve apiKey from file")
        return nil
    }
    return YelpV3AuthenticationToken(apiKey: apiKey)
  }
  
  private static func getKeys() -> [String: String] {
    guard
      let path = Bundle.main.path(forResource: "secrets", ofType: "plist"),
      let keys = NSDictionary(contentsOfFile: path) as? [String: String]
      else {
        assertionFailure("Unable to load secrets property list, contact dnseitz@gmail.com if you need the file")
        return [:]
    }
    return keys
  }
}

final class YelpV3Authenticator: Authenticator {
  typealias TokenType = YelpV3AuthenticationToken
  
  class func authenticate(with token: YelpV3AuthenticationToken, completionHandler: @escaping (Result<NetworkAdapter, Error>) -> Void) {
    APIFactory.Yelp.V3.authenticate(apiKey: token.apiKey) { error in
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
