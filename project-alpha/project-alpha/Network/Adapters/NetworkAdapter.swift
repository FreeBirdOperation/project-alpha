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

typealias SearchResult = Result<[BusinessModel], APIError>
typealias LookupResult = Result<BusinessModel, APIError>

struct SearchParameters {
  var location: CLLocation
  var distance: Int
}

struct LookupParameters {
  var id: String
}

@objc
protocol NetworkObserver: class {
  func loadBegan()
  func loadEnded()
}

protocol NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void)
  
  func makeLookupRequest(with params: LookupParameters, completionHandler: @escaping (LookupResult) -> Void)
  
  func addObserver(_ observer: NetworkObserver)
  func removeObserver(_ observer: NetworkObserver)
}
