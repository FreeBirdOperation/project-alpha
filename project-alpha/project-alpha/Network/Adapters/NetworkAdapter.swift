//
//  NetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/14/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

typealias SearchResult = Result<[BusinessModel], APIError>

struct SearchParameters {
  var distance: Int
}

protocol NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void)
}
