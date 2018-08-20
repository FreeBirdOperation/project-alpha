//
//  YelpV3ReviewResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 5/26/18.
//  Copyright © 2018 Daniel Seitz. All rights reserved.
//

import Foundation

public final class YelpV3ReviewResponse: YelpV3Response {
  
  private enum Params {
    static let error = "error"
    static let reviews = "reviews"
  }
  
  public var error: APIError?
  public let reviews: [YelpReview]

  public init(withJSON data: [String : AnyObject]) throws {
    let decoder = JSONDecoder()
    if let error = data[Params.error] as? [String: AnyObject] {
      self.error = YelpV3ReviewResponse.parse(error: error)
    }
    else {
      self.error = nil
    }

    do {
      self.reviews = try decoder.decode(Array<YelpReview>.self,
                                        from: JSONSerialization.data(withJSONObject: data[Params.reviews] as Any))
    }
    catch {
      throw ParseError.decoderFailed(cause: error)
    }
  }
}
