//
//  YelpV3ReviewParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 5/26/18.
//  Copyright © 2018 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpV3ReviewParameters {
  
  let id: String
  let locale: LocaleParameter?
  
  public init(id: String, locale: LocaleParameter? = nil) {
    self.id = id
    self.locale = locale
  }
}
