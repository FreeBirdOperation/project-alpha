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
  var viewController: UIViewController!
  
  override func setUp() {
    super.setUp()

    guard let viewController = viewController else {
      preconditionFailure("Subclassing test cases must set viewController value before calling setUp")
    }

    viewController.viewDidLoad()
  }
  
  func makeViewAppear(_ animated: Bool) {
    viewController.viewWillAppear(animated)
    viewController.viewDidAppear(animated)
  }
  
  func makeViewDisappear(_ animated: Bool) {
    viewController.viewWillDisappear(animated)
    viewController.viewDidDisappear(animated)
  }
}
