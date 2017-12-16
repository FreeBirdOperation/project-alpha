//
//  ResultActionHandler.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/26/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import YAPI

protocol ResultViewControllerDelegate: class {
  var viewController: ResultViewController? { get set }
  
  func retrieveBusinesses(with params: SearchParameters,
                          completionHandler: @escaping (Result<[BusinessModel], APIError>) -> Void)
  func selectOption(_ businessModel: BusinessModel?)
  func discardOption(_ businessModel: BusinessModel?)
}

class ResultActionHandler: ResultViewControllerDelegate {
  let networkAdapter: NetworkAdapter
  private weak var _viewController: ResultViewController?
  
  var viewController: ResultViewController? {
    get {
      return _viewController
    }
    set {
      guard _viewController == nil else {
        assertionFailure("Attempted to bind action handler to more than one view controller")
        return
      }
      _viewController = newValue
    }
  }
  
  private var searchInProgress: Bool
  
  init(networkAdapter: NetworkAdapter) {
    self.networkAdapter = networkAdapter
    self.searchInProgress = false
  }
  
  func retrieveBusinesses(with params: SearchParameters,
                          completionHandler: @escaping (Result<[BusinessModel], APIError>) -> Void) {
    // So we don't have to worry about non-atomic operations when setting the searchInProgress flag
    assert(Thread.isMainThread, "Only request new businesses from the main thread")

    guard !searchInProgress else { return }

    log(.info, for: .general, message: "Loading next batch of businesses")

    searchInProgress = true
    networkAdapter.makeSearchRequest(with: params) { [weak self] result in
      self?.searchInProgress = false
      completionHandler(result)
    }
  }
  
  func selectOption(_ businessModel: BusinessModel?) {
    defer {
      viewController?.showNextOption()
    }
    guard let businessModel = businessModel else { return }

    print("Selected \(businessModel.name)")
  }
  
  func discardOption(_ businessModel: BusinessModel?) {
    defer {
      viewController?.showNextOption()
    }
    guard let businessModel = businessModel else { return }

    print("Discarded \(businessModel.name)")
  }
}
