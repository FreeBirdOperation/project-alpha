//
//  NetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/14/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation
import YAPI

typealias SearchResult = Result<[BusinessModel], ResultError>
typealias LookupResult = Result<BusinessModel, APIError>
typealias ReviewResult = Result<[ReviewModel], APIError>

struct SearchParameters {
  let location: CLLocation
  let distance: Int
  let offset: Int
  let limit: Int
  let locale: PALocale?
  
  init(location: CLLocation, distance: Int, limit: Int, locale: PALocale? = nil) {
    self.location = location
    self.distance = distance
    self.limit = limit
    self.offset = 0
    self.locale = locale
  }
  
  private init(withOffsetFor searchParams: SearchParameters) {
    self.location = searchParams.location
    self.distance = searchParams.distance
    self.limit = searchParams.limit
    self.offset = searchParams.offset + searchParams.limit
    self.locale = searchParams.locale
  }
  
  func nextOffset() -> SearchParameters {
    return SearchParameters(withOffsetFor: self)
  }
}

struct LookupParameters {
  var id: String
  var locale: PALocale?
}

struct ReviewParameters {
  var id: String
  var locale: PALocale?
}

@objc
protocol NetworkObserver: class {
  func loadBegan()
  func loadEnded()
}

protocol NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void)
  
  func makeLookupRequest(with params: LookupParameters, completionHandler: @escaping (LookupResult) -> Void)
  
  func makeReviewRequest(with params: ReviewParameters, completionHandler: @escaping (ReviewResult) -> Void)
  
  func addObserver(_ observer: NetworkObserver)
  func removeObserver(_ observer: NetworkObserver)
}

extension NetworkAdapter {
  // TODO: Examine ways to make this type signature better (AnyRequest?)
  func coalesceRequests(with requestParamsList: [Any], completionHandler: @escaping ([Any]) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let dispatchGroup = DispatchGroup()
      var results: [Any] = []
      
      for params in requestParamsList {
        if let params = params as? SearchParameters {
          dispatchGroup.enter()
          self.makeSearchRequest(with: params) { result in
            results.append(result)
            dispatchGroup.leave()
          }
        } else if let params = params as? LookupParameters {
          dispatchGroup.enter()
          self.makeLookupRequest(with: params) { result in
            results.append(result)
            dispatchGroup.leave()
          }
        } else if let params = params as? ReviewParameters {
          dispatchGroup.enter()
          self.makeReviewRequest(with: params) { result in
            results.append(result)
            dispatchGroup.leave()
          }
        }
      }
      
      dispatchGroup.notify(queue: .main) {
        completionHandler(results)
      }
    }
  }
}
