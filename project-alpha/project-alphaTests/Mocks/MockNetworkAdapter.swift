//
//  MockNetworkAdapter.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/10/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation

@testable import project_alpha

extension Mock {
  static var networkAdapter: NetworkAdapter { return NetworkAdapter() }
  
  class NetworkAdapter: project_alpha.NetworkAdapter {
    private(set) var madeSearchRequest: Bool = false
    
    var nextResult: SearchResult = .ok([])
    
    var asyncAfter: DispatchTimeInterval?
    
    fileprivate init() {}

    func makeSearchRequest(with params: SearchParameters, completionHandler: @escaping (SearchResult) -> Void) {
      if let asyncAfter = asyncAfter {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + asyncAfter) {
          completionHandler(self.nextResult)
        }
      }
      else {
        completionHandler(nextResult)
      }
      madeSearchRequest = true
    }
  }
}
