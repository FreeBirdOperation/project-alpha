//
//  YelpV3LookupParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 2/17/18.
//  Copyright © 2018 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpV3LookupParameters {
  
  let id: String
  let locale: LocaleParameter?
  
  public init(id: String, locale: LocaleParameter? = nil) {
    self.id = id
    self.locale = locale
  }
}
