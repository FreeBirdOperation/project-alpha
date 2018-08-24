//
//  YelpCategoryParser.swift
//  project-alpha
//
//  Created by Daniel Seitz on 8/23/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

struct YelpCategoryParser {
  /// Categories that are acceptable in the app,
  /// nil means all categories can be used
  var allowableCategories: [String]? = nil
  
  /// Should a category be allowed if its parent
  /// category is allowed
  var allowCategoryIfParentIsAllowed: Bool = true
  
  /// Sites that are available,
  /// nil means all sites can be used
  var allowableSites: [String]? = nil
  
  func getCategories() -> [YelpCategory] {
    guard let url = Bundle.main.url(forResource: "categories", withExtension: "json") else {
      assertionFailure("Category file not found")
      return []
    }
    
    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      let categories = try decoder.decode(Array<YelpCategory>.self, from: data)
      
      return categories.filter { isCategoryAllowed($0) }
    } catch {
      log(.error, for: .general, message: "Error parsing: \(error)")
    }
    return []
  }
  
  private func isCategoryAllowed(_ category: YelpCategory) -> Bool {
    let isValidCategory: Bool
    let hasValidCountry: Bool
    
    if let allowableCategories = allowableCategories {
      if allowableCategories.contains(category.alias) {
        isValidCategory = true
      } else if allowCategoryIfParentIsAllowed == true &&
                category.parents.first(where: {
                  allowableCategories.contains($0)
                }) != nil {
        isValidCategory = true
      } else {
        isValidCategory = false
      }
    } else {
      isValidCategory = true
    }
    
    if let allowableSites = allowableSites {
      if category.countryWhitelist?.first(where: { allowableSites.contains($0) }) != nil {
        hasValidCountry = true
      } else if category.countryBlacklist?.first(where: { allowableSites.contains($0) }) != nil {
        hasValidCountry = false
      } else {
        hasValidCountry = true
      }
    } else {
      hasValidCountry = true
    }
    
    return isValidCategory && hasValidCountry
  }
}
