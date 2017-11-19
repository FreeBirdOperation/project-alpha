//
//  GoogleRequest.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/15/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

protocol GoogleRequest: Request {}

extension GoogleRequest {
  public var host: String {
    return APIEndpoints.Google.host
  }
}
