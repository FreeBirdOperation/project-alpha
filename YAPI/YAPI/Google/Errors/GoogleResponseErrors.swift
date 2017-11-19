//
//  GoogleResponseErrors.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/17/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

enum GoogleResponseError: APIError {
  
  /// You are over your quota
  case overQueryLimit(message: String?)
  
  /// Indicates that your request was denied, generally because of
  /// lack of an invalid key parameter.
  case requestDenied(message: String?)
  
  /// Generally indicates that a required query parameter is missing
  case invalidRequest(message: String?)
}

extension GoogleResponseError: CustomStringConvertible {
  var description: String {
    switch self {
    case .overQueryLimit(message: let message):
      let message = message != nil ? ": <\(String(describing: message))>" : ""
      return "You are over your request quota\(message)"
    case .requestDenied(message: let message):
      let message = message != nil ? ": <\(String(describing: message))>" : ""
      return "Request was denied\(message)"
    case .invalidRequest(message: let message):
      let message = message != nil ? ": <\(String(describing: message))>" : ""
      return "Invalid request\(message)"
    }
  }
}

