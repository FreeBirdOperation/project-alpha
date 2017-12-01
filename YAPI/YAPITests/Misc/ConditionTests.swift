//
//  ConditionTests.swift
//  YAPITests
//
//  Created by Daniel Seitz on 11/30/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation
import XCTest

@testable import YAPI

class ConditionTests: YAPIXCTestCase {
  func test_Condition_WaitReturnsBroadcastedValue() {
    let condition = Condition<Int>()
    let expect = expectation(description: "Thread was awoken")
    let expectedValue = 5
    var actualValue: Int? = nil
    
    DispatchQueue.main.async {
      actualValue = condition.wait()
      expect.fulfill()
    }
    
    condition.broadcast(value: 5)
    
    waitForExpectations(timeout: 1.0) { error in
      XCTAssertNil(error)
      XCTAssertEqual(actualValue, expectedValue)
    }
  }
}
