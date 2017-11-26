//
//  ResultActionHandler.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/26/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import YAPI

protocol ResultViewControllerOperations {
  func retrieveBusinesses(with params: SearchParameters,
                          completionHandler: @escaping (Result<[BusinessModel], APIError>) -> Void)
  func selectOption()
  func discardOption()
}

class ResultActionHandler: ResultViewControllerOperations {
  // FIXME: I think there's a reference cycle here, investigate
  let viewController: ResultViewController
  
  let networkAdapter: NetworkAdapter
  
  init(viewController: ResultViewController, networkAdapter: NetworkAdapter) {
    self.viewController = viewController
    self.networkAdapter = networkAdapter
  }
  
  func retrieveBusinesses(with params: SearchParameters,
                          completionHandler: @escaping (Result<[BusinessModel], APIError>) -> Void) {
    networkAdapter.makeSearchRequest(with: params, completionHandler: completionHandler)
  }
  
  func selectOption() {
    print("Selected")
  }
  
  func discardOption() {
    print("Discarded")
  }
}
