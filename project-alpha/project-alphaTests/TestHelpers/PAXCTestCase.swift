//
//  PAXCTestCase.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/3/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI
import XCTest

// project-alpha test case override point
class PAXCTestCase: XCTestCase {
  override func setUp() {
    super.setUp()

    YAPI.Asserts.shouldAssert = false
  }
  
  override func tearDown() {
    YAPI.Asserts.shouldAssert = true
    
    super.tearDown()
  }
}
