//
//  MockResultViewControllerDelegate.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/15/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI
@testable import project_alpha

extension Mock.ResultScreen {
  static var delegate: Delegate { return Delegate() }

  class Delegate: ResultViewControllerDelegate {
    
    var viewController: ResultViewController?
    
    private(set) var selected: Bool = false
    private(set) var discarded: Bool = false
    private(set) var retrieved: Bool = false
    
    var nextResult: Result<[BusinessModel], APIError> = .ok(Array(repeating: Mock.businessModel, count: 10))
    
    fileprivate init() {}
    
    func retrieveBusinesses(with params: SearchParameters, completionHandler: @escaping (Result<[BusinessModel], APIError>) -> Void) {
      retrieved = true
      completionHandler(nextResult)
    }
    
    func selectOption(_ businessModel: BusinessModel?) {
      selected = true
    }
    
    func discardOption(_ businessModel: BusinessModel?) {
      discarded = true
    }
    
  }
}

