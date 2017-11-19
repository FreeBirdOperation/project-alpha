//
//  GoogleAuthentication.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

struct GoogleAuthToken {
  let token: String
  
  init(_ token: String) {
    self.token = token
  }
}

enum GoogleAuth {
  static var token: GoogleAuthToken?
}
