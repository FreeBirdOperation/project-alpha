//
//  GooglePlaceSearchResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/15/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

public final class GooglePlaceSearchResponse: Response {

  public let error: YelpResponseError?

  public init(withJSON data: [String : AnyObject]) throws {
    throw YelpResponseError.failedToParse(cause: ParseError.unknown)
  }
}
