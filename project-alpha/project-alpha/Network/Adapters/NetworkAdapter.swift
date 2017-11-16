//
//  NetworkAdapter.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/14/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

struct SearchParameters {
  var distance: Int
}

protocol BusinessModel {
  var name: String { get }
}

protocol NetworkAdapter {
  func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (Result<[BusinessModel], Error>) -> Void)
}
