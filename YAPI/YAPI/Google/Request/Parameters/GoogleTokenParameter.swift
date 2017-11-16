//
//  GoogleTokenParameter.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

struct GoogleTokenParameter: StringParameter {
  let internalValue: String
  let key: String = "key"
}

extension GoogleTokenParameter {
  public typealias UnicodeScalarLiteralType = Character
  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  
  public init(stringLiteral value: StringLiteralType) {
    self.internalValue = value
  }
  
  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self.internalValue = "\(value)"
  }
  
  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self.internalValue = value
  }
}

