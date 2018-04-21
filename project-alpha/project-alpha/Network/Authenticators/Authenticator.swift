//
//  Authenticator.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/14/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

typealias AuthenticationCompletionHandler = (Result<NetworkAdapter, Error>) -> Void

protocol Authenticator {
  associatedtype TokenType
  
  static func authenticate(with token: TokenType, completionHandler: @escaping AuthenticationCompletionHandler)
}
