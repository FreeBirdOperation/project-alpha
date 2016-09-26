//
//  YelpRequestTestCase.swift
//  YAPI
//
//  Created by Daniel Seitz on 9/11/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class YelpRequestTestCase : YAPIXCTestCase {
  var session: YelpHTTPClient!
  var request: YelpRequest!
  let mockSession = MockURLSession()
  
  override func setUp() {
    super.setUp()
    
    session = YelpHTTPClient(session: mockSession)
    request = YelpBusinessRequest(businessId: "", session: session)
  }
  
  override func tearDown() {
    mockSession.nextData = nil
    mockSession.nextError = nil
    
    super.tearDown()
  }
  
  func test_SendRequest_WhereRequestErrors_GivesTheError() {
    let mockError = NSError(domain: "error", code: 0, userInfo: nil)
    mockSession.nextError = mockError
    request.send() { (response, error) -> Void in
      XCTAssertNil(response)
      XCTAssertNotNil(error)
      
      XCTAssert(error as! YelpRequestError == .failedToSendRequest(mockError))
    }
  }
  
  func test_SendRequest_RecievesNoData_GivesAnError() {
    request.send() { (response, error) -> Void in
      XCTAssertNil(response)
      XCTAssertNotNil(error)
      
      XCTAssert(error as! YelpResponseError == .noDataRecieved)
    }
  }
  
  func test_SendRequest_RecievesBadData_GivesAnError() {
    mockSession.nextData = Data()
    request.send() { (response, error) -> Void in
      XCTAssertNil(response)
      XCTAssertNotNil(error)
      
      XCTAssert(error as! YelpResponseError == .failedToParse)
    }
  }
  
  func test_SendRequest_RecievesYelpError_GivesTheError() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpErrorResponse, options: .ignoreUnknownCharacters)
    request.send() { (response, error) -> Void in
      XCTAssertNotNil(response)
      XCTAssertNotNil(error)
      
      XCTAssertNil(response!.businesses)
      XCTAssert((self.request as AnyObject) === (response!.request as AnyObject))
      XCTAssertNotNil(response!.error)
      XCTAssert(response!.error! == .invalidParameter(field: "location"))
      XCTAssert(response!.wasSuccessful == false)
      
      XCTAssert(response!.error == (error as! YelpResponseError))
    }
  }
}
