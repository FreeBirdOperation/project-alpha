//
//  GooglePlaceSearchResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/15/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

final class GooglePlaceSearchResponse: Response {

  let error: YelpResponseError?

  init(withJSON data: [String : AnyObject]) throws {
    throw NSError()
  }
}
