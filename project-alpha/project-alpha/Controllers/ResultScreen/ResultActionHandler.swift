//
//  ResultActionHandler.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/26/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
import Contacts
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
    print("Coordinate: \(businessModel.coordinate)")
    
    // Fill in information like this to get address info without geocoding
    let addressDictionary = [
      // NOTE: If we have to we can force apple maps to display the name of
      // the location like this, this isn't ideal since it seems like a misuse
      // of the key
      CNPostalAddressStreetKey: businessModel.name
//      CNPostalAddressPostalCodeKey: "97201",
//      CNPostalAddressCityKey: "Portland",
//      CNPostalAddressStateKey: "OR",
//      CNPostalAddressCountryKey: "United States",
//      CNPostalAddressISOCountryCodeKey: "US"
    ]
    
    let placemark = MKPlacemark(coordinate: businessModel.coordinate, addressDictionary: addressDictionary)
    let mapItem = MKMapItem(placemark: placemark)
    
    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
  }
  
  func discardOption(_ businessModel: BusinessModel?) {
    defer {
      viewController?.showNextOption()
    }
    guard let businessModel = businessModel else { return }

    print("Discarded \(businessModel.name)")
  }
}
