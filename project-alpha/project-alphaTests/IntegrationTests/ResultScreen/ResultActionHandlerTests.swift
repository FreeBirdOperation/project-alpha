//
//  ResultActionHandlerTests.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/10/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import XCTest
@testable import project_alpha

class ResultActionHandlerTests: PAXCTestCase {
  var actionHandler: ResultActionHandler!
  var mockNetworkAdapter: Mock.NetworkAdapter!

  override func setUp() {
    super.setUp()

    mockNetworkAdapter = Mock.networkAdapter
    actionHandler = ResultActionHandler(networkAdapter: mockNetworkAdapter)
  }
  
  func test_ResultActionHandler_RetrieveBusinessesMakesNetworkRequest() {
    let params = SearchParameters(distance: 10)

    XCTAssertFalse(mockNetworkAdapter.madeSearchRequest)

    actionHandler.retrieveBusinesses(with: params) { result in /* Mock Handler */ }
    
    XCTAssertTrue(mockNetworkAdapter.madeSearchRequest)
  }
  
  func test_ResultActionHandler_OnlyOneRetrieveBusinessesCallCanBeMadeAtOnce() {
    let params = SearchParameters(distance: 10)
    let expect = expectation(description: "First network call finished")
    mockNetworkAdapter.asyncAfter = .milliseconds(100)
    
    actionHandler.retrieveBusinesses(with: params) { result in
      expect.fulfill()
    }
    
    actionHandler.retrieveBusinesses(with: params) { result in
      XCTFail("Second network request should not be made")
    }
    
    actionHandler.retrieveBusinesses(with: params) { result in
      XCTFail("Third network request should not be made")
    }
    
    waitForExpectations(timeout: 1.0)
  }
  
  func test_ResultActionHandler_SelectOption() {
    // Test stub for when this is actually implemented
    
    actionHandler.selectOption(Mock.businessModel)
  }
  
  func test_ResultActionHandler_DiscardOption() {
    // Test stub for when this is actually implemented
    
    actionHandler.discardOption(Mock.businessModel)
  }
}
