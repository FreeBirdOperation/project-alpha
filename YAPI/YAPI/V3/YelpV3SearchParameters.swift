//
//  YelpV3SearchParameters.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/3/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public struct YelpV3SearchParameters {
  public struct Term : StringParameter {
    let internalValue: String
    
    public var key: String = "term"
  }
  
  public struct Radius : IntParameter {
    let internalValue: Int
    
    public let key: String = "radius"
    
    public init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  public struct Categories : ArrayParameter {
    // TODO: Look at coming back and changing this to some Category type?
    public typealias Element = String
    
    let internalValue: [Element]
    
    public let key: String = "categories"
    
    public init(_ elements: [Element]) {
      self.internalValue = elements
    }
  }
  
  public struct Limit: IntParameter {
    let internalValue: Int
    public let key: String = "limit"
    
    public init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  public struct Offset: IntParameter {
    let internalValue: Int
    public let key: String = "offset"
    
    public init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  public enum SortMode: String, Parameter {
    public var key: String {
      return "sort"
    }
    
    public var value: String {
      return String(self.rawValue)
    }
    
    case bestMatch = "best_match"
    case highestRated = "rating"
    case reviewCount = "review_count"
    case distance = "distance"
  }
  
  public struct Price: ArrayParameter {
    public typealias Element = YelpPrice
    
    let internalValue: [Element]
    public let key: String = "price"
    
    public init(_ elements: [Element]) {
      self.internalValue = elements
    }
    
    public init(low: Element, high: Element) {
      assert(low.rawValue <= high.rawValue)
      
      let lowValue = min(low.rawValue, high.rawValue)
      let highValue = max(low.rawValue, high.rawValue)
      
      let range = Array(lowValue...highValue).flatMap { Element(rawValue: $0) }
      self.init(range)
    }
  }
  
  public struct OpenNow: BooleanParameter {
    let internalValue: Bool
    public let key: String = "open_now"
    
    public init(booleanLiteral value: BooleanLiteralType) {
      self.internalValue = value
    }
  }
  
  public struct OpenAt: IntParameter {
    let internalValue: Int
    public let key: String = "open_at"
    
    public init(integerLiteral value: IntegerLiteralType) {
      self.internalValue = value
    }
  }
  
  public struct Attributes: ArrayParameter {
    public enum Options: String {
      /// Hot and New businesses
      case hotAndNew = "hot_and_new"
      
      /// Businesses that have the Request a Quote feature
      case requestAQuote = "request_a_quote"
      
      /// Businesses that have an online waitlist
      case waitlistReservation = "waitlist_reservation"
      
      /// Businesses that offer Cash Back
      case cashback = "cashback"
      
      /// Businesses that offer Deals
      case deals = "deals"
      
      /// Businesses that provide gender neutral restrooms
      case genderNeutralRestrooms = "gender_neutral_restrooms"
    }
    
    public typealias Element = Options
    
    let internalValue: [Options]
    public let key: String = "attributes"

    public init(_ elements: [Element]) {
      self.internalValue = elements
    }
  }
  
  /// Search term (e.g. "food", "restaurants"). If term isn’t included we search
  /// everything. The term keyword also accepts business names such as "Starbucks".
  public let term: Term?
  
  /// Location to search near by
  public let location: YelpV3LocationParameter
  
  /// Search radius in meters. If the value is too large, a AREA_TOO_LARGE error
  /// may be returned. The max value is 40000 meters (25 miles).
  public let radius: Radius?
  
  /// Categories to filter the search results with.
  public let categories: Categories?
  
  /// Specify the locale to return the business information in.
  public let locale: LocaleParameter?
  
  /// Number of business results to return. By default, it will return 20. Maximum is 50.
  public let limit: Limit?
  
  /// Offset the list of returned business results by this amount.
  public let offset: Offset?
  
  /**
      Sort the results by one of the these modes: best_match, rating, review_count or
      distance. By default it's best_match. The rating sort is not strictly sorted by
      the rating value, but by an adjusted rating value that takes into account the number
      of ratings, similar to a bayesian average. This is so a business with 1 rating of 5
      stars doesn’t immediately jump to the top.
   */
  public let sortMode: SortMode?
  
  /// Pricing levels to filter the search result with
  public let price: Price?
  
  /// When set to true, only return the businesses open now. Notice that open_at and open_now
  /// cannot be used together.
  public let openNow: OpenNow?
  
  /// An integer represending the Unix time in the same timezone of the search location.
  /// If specified, it will return business open at the given time.
  public let openAt: OpenAt?
  /**
      Additional filters to restrict search results.
   
      If multiple attributes are used, only businesses that satisfy ALL
      attributes will be returned in search results.
   */
  public let attributes: Attributes?
  
  public init(location: YelpV3LocationParameter,
               term: Term? = nil,
               radius: Radius? = nil,
               categories: Categories? = nil,
               locale: LocaleParameter? = nil,
               limit: Limit? = nil,
               offset: Offset? = nil,
               sortBy: SortMode? = nil,
               price: Price? = nil,
               openNow: OpenNow? = nil,
               openAt: OpenAt? = nil,
               attributes: Attributes? = nil) {
    self.location = location
    self.term = term
    self.radius = radius
    self.categories = categories
    self.locale = locale
    self.limit = limit
    self.offset = offset
    self.sortMode = sortBy
    self.price = price
    self.openNow = openNow
    self.openAt = openAt
    self.attributes = attributes
  }
}

extension YelpV3SearchParameters.Term : ExpressibleByStringLiteral {
  public typealias UnicodeScalarLiteralType = Character
  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  
  public init(stringLiteral value: StringLiteralType) {
    self.internalValue = value
  }
  
  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self.internalValue = "\(value)"
  }
  
  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self.internalValue = value
  }
}
