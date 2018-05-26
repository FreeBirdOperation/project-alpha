//
//  PALocale.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/26/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

// Supported Languages
enum PALanguage: String {
  case english = "en"
  case spanish = "es"
}

struct PALocale {
  var language: PALanguage
  var country: String?
  
  static var current: PALocale? {
    guard
      let languageCode = Locale.current.languageCode,
      let language = PALanguage(rawValue: languageCode)
      else {
        return nil
    }
    
    return PALocale(language: language, country: Locale.current.regionCode)
  }
}
