//
//  ViewControllerIntegrationTestCase.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/3/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import XCTest

class ViewControllerIntegrationTestCase: PAXCTestCase {
  private var _viewController: UIViewController!
  
  var viewController: UIViewController {
    get {
      return _viewController
    }
    set {
      _viewController = newValue
      _viewController.viewDidLoad()
    }
  }
  
  override func setUp() {
    super.setUp()
    
    guard _viewController != nil else {
      preconditionFailure("Subclassing test cases must set viewController value before calling setUp")
    }
  }
  
  override func tearDown() {
    _viewController = nil

    super.tearDown()
  }
  
  final func makeViewAppear(_ animated: Bool) {
    viewController.viewWillAppear(animated)
    viewController.viewDidAppear(animated)
  }
  
  final func makeViewDisappear(_ animated: Bool) {
    viewController.viewWillDisappear(animated)
    viewController.viewDidDisappear(animated)
  }
}
