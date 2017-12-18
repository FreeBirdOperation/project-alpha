//
//  ResultViewControllerTests.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/9/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI
import XCTest
@testable import project_alpha

class ResultViewControllerTests: ViewControllerIntegrationTestCase {
  let mockSearchParameters = SearchParameters(distance: 100)
  private var mockDelegate: Mock.ResultScreen.Delegate = Mock.ResultScreen.delegate
  
  var resultViewController: ResultViewController {
    return viewController as! ResultViewController
  }
  
  override func setUp() {
    mockDelegate = Mock.ResultScreen.delegate
    let pageModel = ResultViewControllerPageModel(delegate: mockDelegate,
                                                  searchParameters: mockSearchParameters)
    viewController = ResultViewController(pageModel: pageModel)
    
    super.setUp()
  }
  
  func test_ResultViewController_SetsDelegateViewControllerAsSelf() {
    XCTAssertTrue(mockDelegate.viewController === viewController)
  }
  
  func test_ResultViewController_RetrievesBusinessesOnInitialization() {
    XCTAssertTrue(mockDelegate.retrieved)
    XCTAssertEqual(resultViewController.businesses.count, 9)
  }
  
  func test_ResultViewController_ShowNextOption_RemovesFromBusinessArray() {
    XCTAssertEqual(resultViewController.businesses.count, 9)
    
    resultViewController.showNextOption()
    
    XCTAssertEqual(resultViewController.businesses.count, 8)
  }
  
  func test_ResultViewController_BusinessesBelowThresholdFetchesNewBusinesses() {
    let pageModel = ResultViewControllerPageModel(delegate: mockDelegate, searchParameters: mockSearchParameters, refreshThreshold: 10)
    viewController = ResultViewController(pageModel: pageModel)
    
    XCTAssertEqual(resultViewController.businesses.count, 9)
    
    resultViewController.showNextOption()
    
    XCTAssertEqual(resultViewController.businesses.count, 18)
  }
  
  func test_ResultViewController_SwipeRightCallsDelegateSelectionMethod() {
    XCTAssertFalse(mockDelegate.selected)

    resultViewController.swipe(.right, animated: false)
    
    XCTAssertTrue(self.mockDelegate.selected)
  }
  
  func test_ResultViewController_SwipeLeftCallsDelegateDiscardMethod() {
    XCTAssertFalse(mockDelegate.discarded)
    
    resultViewController.swipe(.left, animated: false)
    
    XCTAssertTrue(self.mockDelegate.discarded)
  }
}
