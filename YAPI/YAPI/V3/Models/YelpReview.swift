//
//  YelpReview.swift
//  YAPI
//
//  Created by Daniel Seitz on 5/26/18.
//  Copyright © 2018 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpReview: Decodable {
  public struct User: Decodable {
    enum CodingKeys: String, CodingKey {
      case image = "image_url"
      case name
    }
    public let image: ImageReference?
    public let name: String
  }
  public let id: String
  public let rating: Int
  public let user: User
  public let text: String
  // FIXME: need to parse time_created manually
//  public let time_created: Date
  public let url: URL
}
