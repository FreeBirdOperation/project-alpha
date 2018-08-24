//
//  YelpCategory.swift
//  project-alpha
//
//  Created by Daniel Seitz on 8/23/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

struct YelpCategory: Decodable {
  enum CodingKeys: String, CodingKey {
    case alias = "alias"
    case title = "title"
    case parents = "parents"
    case countryWhitelist = "country_whitelist"
    case countryBlacklist = "country_blacklist"
  }
  
  let alias: String
  let title: String
  let parents: [String]
  let countryWhitelist: [String]?
  let countryBlacklist: [String]?
}
