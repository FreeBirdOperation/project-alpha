//
//  ImageReferenceTests.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/29/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import XCTest
@testable import YAPI

class ImageReferenceTests: YAPIXCTestCase {
  
  var session: HTTPClient!
  let mockSession = MockURLSession()
  
  override func setUp() {
    super.setUp()
    
    session = HTTPClient(session: mockSession)
  }
  
  override func tearDown() {
    ImageReference.globalCache.flush()
    
    mockSession.nextData = nil
    mockSession.nextError = nil
    mockSession.asyncAfter = nil
    
    super.tearDown()
  }
  
  func test_Init_WithInvalidURLStringFails() {
    let imageReference = ImageReference(from: "")
    
    XCTAssertNil(imageReference)
  }
  
  func test_LoadImage_WhileLoadIsInFlight_DefersLoadForImage() {
    mockSession.asyncAfter = .milliseconds(100)
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    var image: UIImage? = nil
    var image2: UIImage? = nil
    let expect = expectation(description: "The image load finished")
    let expect2 = expectation(description: "The second image load finished")
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    
    imageReference.load { result in
      XCTAssert(result.isOk())
      
      image = result.unwrap()
      expect.fulfill()
    }
    
    imageReference.load { result in
      XCTAssert(result.isOk())
      
      image2 = result.unwrap()
      expect2.fulfill()
    }
    
    waitForExpectations(timeout: 1.0) { error in
      XCTAssertNil(error)
      XCTAssertNotNil(image)
      XCTAssertNotNil(image2)
    }
  }
  
  func test_LoadImage_WhileLoadIsInFlight_MultipleLoads_DefersLoadsForImage() {
    mockSession.asyncAfter = .milliseconds(100)
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)

    var image: UIImage? = nil
    var image2: UIImage? = nil
    var image3: UIImage? = nil
    var image4: UIImage? = nil

    let expect = expectation(description: "The image load finished")
    let expect2 = expectation(description: "The second image load finished")
    let expect3 = expectation(description: "The third image load finished")
    let expect4 = expectation(description: "The fourth image load finished")
    
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    
    imageReference.load { result in
      XCTAssert(result.isOk())
      
      image = result.unwrap()
      expect.fulfill()
    }
    
    imageReference.load { result in
      XCTAssert(result.isOk())
      
      image2 = result.unwrap()
      expect2.fulfill()
    }
    
    imageReference.load { result in
      XCTAssert(result.isOk())
      
      image3 = result.unwrap()
      expect3.fulfill()
    }
    
    imageReference.load { result in
      XCTAssert(result.isOk())
      
      image4 = result.unwrap()
      expect4.fulfill()
    }
    
    waitForExpectations(timeout: 1.0) { error in
      XCTAssertNil(error)
      XCTAssertNotNil(image)
      XCTAssertNotNil(image2)
      XCTAssertNotNil(image3)
      XCTAssertNotNil(image4)
    }
  }
  
  func test_LoadImage_LoadsAnImageFromValidData() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    imageReference.load() { (result) -> Void in
      XCTAssert(result.isOk())
    }
  }
  
  func test_LoadImage_LoadsAnImageFromValidData_CachesTheImage() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    imageReference.load() { (result) -> Void in }
    let imageReference2 = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    imageReference2.load() { (result) -> Void in }
    XCTAssertNotNil(imageReference.cachedImage)
    XCTAssertNotNil(imageReference2.cachedImage)
  }
  
  func test_LoadImage_LoadsAnImageFromInvalidData_GivesAnError() {
    mockSession.nextData = Data()
    let imageReference = ImageReference(from: URL(fileURLWithPath: ""), session: session)
    imageReference.load() { (result) -> Void in
      XCTAssert(result.isErr())
      
      guard case .invalidData = result.unwrapErr() else {
        return XCTFail("Error was wrong type")
      }
    }
  }
  
  func test_LoadImage_WhereRequestErrors_GivesTheError() {
    let mockError = NSError(domain: "error", code: 0, userInfo: nil)
    mockSession.nextError = mockError
    let imageReference = ImageReference(from: URL(fileURLWithPath: ""), session: session)
    imageReference.load() { (result) -> Void in
      XCTAssert(result.isErr())
      
      guard case .requestError(mockError) = result.unwrapErr() else {
        return XCTFail("Error was wrong type")
      }
    }
  }
  
  func test_LoadImage_RecievesNoData_GivesAnError() {
    let imageReference = ImageReference(from: URL(fileURLWithPath: ""), session: session)
    imageReference.load() { (result) -> Void in
      XCTAssert(result.isErr())
      
      guard case .noDataReceived = result.unwrapErr() else {
        return XCTFail("Error was wrong type")
      }
    }
  }
  
  func test_LoadImage_WithDifferentImageReferencesToSameURL_GivesCachedImage() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    let imageReference2 = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    
    imageReference.load() { (result) -> Void in
      imageReference2.load() { (result2) -> Void in
        XCTAssert(result.isOk())
        XCTAssert(result2.isOk())
        
        let image = result.unwrap()
        let image2 = result2.unwrap()
        
        let imageData = UIImagePNGRepresentation(image)!
        let imageData2 = UIImagePNGRepresentation(image2)!
        let cachedImageData = UIImagePNGRepresentation(imageReference.cachedImage!)!
        let cachedImageData2 = UIImagePNGRepresentation(imageReference2.cachedImage!)!
        
        XCTAssert(imageReference.cachedImage !== image)
        XCTAssert(imageReference.cachedImage !== image2)
        XCTAssert(cachedImageData == imageData)
        XCTAssert(cachedImageData == imageData2)
        XCTAssert(imageReference2.cachedImage !== image)
        XCTAssert(imageReference2.cachedImage !== image2)
        XCTAssert(cachedImageData2 == imageData)
        XCTAssert(cachedImageData2 == imageData2)
        XCTAssert(image !== image2)
        XCTAssert(imageData == imageData2)
        
        XCTAssert(imageReference.cachedImage !== imageReference2.cachedImage)
      }
    }
  }
  
  func test_LoadImage_StoresImagesInGlobalCache() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let url = URL(string: "http://s3-media3.fl.yelpcdn.com/asdf.jpg")!
    let url2 = URL(string: "http://s3-media3.fl.yelpcdn.com/qwer.jpg")!
    let imageReference = ImageReference(from: url, session: session)
    let imageReference2 = ImageReference(from: url2, session: session)
    
    imageReference.load() { (result) -> Void in
      imageReference2.load() { (result2) -> Void in
        XCTAssert(result.isOk())
        XCTAssert(result2.isOk())
        
        XCTAssert(ImageReference.globalCache.contains(imageReference) == true)
        XCTAssert(ImageReference.globalCache.contains(imageReference2) == true)
      }
    }
  }
  
  func test_CachedImageProperty_ReturnsCopy() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    
    imageReference.load() { (result) -> Void in
      let cachedImage = imageReference.cachedImage
      
      XCTAssertNotNil(cachedImage)
      XCTAssert(result.isOk())
      
      let image = result.unwrap()
      
      // These seem wierd, but we're asserting that the cachedImage property is returning copies of the 
      // image, not the same reference
      XCTAssert(cachedImage !== image)
      XCTAssert(cachedImage !== imageReference.cachedImage)
      XCTAssert(imageReference.cachedImage !== imageReference.cachedImage)
    }
  }
  
  func test_LoadImageWithScale_ScalesTheImage() {
    mockSession.nextData = Data(base64Encoded: ResponseInjections.yelpValidImage, options: .ignoreUnknownCharacters)
    let imageReference = ImageReference(from: URL(string: "http://s3-media3.fl.yelpcdn.com/bphoto/nQK-6_vZMt5n88zsAS94ew/ms.jpg")!, session: session)
    
    imageReference.load(withScale: 0.5) { (result) -> Void in
      XCTAssert(result.isOk())
      
      let image = result.unwrap()
      
      XCTAssert(image.scale == 0.5)
    }
    
    imageReference.load(withScale: 1.5) { (result) -> Void in
      XCTAssert(result.isOk())
      
      let image = result.unwrap()
      
      XCTAssert(image.scale == 1.5)
    }
    
    XCTAssert(imageReference.cachedImage?.scale == 1.0)
  }
}
