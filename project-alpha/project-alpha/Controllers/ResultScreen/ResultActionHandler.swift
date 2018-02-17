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
      // FIXME - HACK: Find a better way to dynamically load specific business information
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
    
    let mapLaunchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    
    if let address = businessModel.address {
      // We have address info from the response, don't bother reverse geocoding the coordinates
      let placemark = MKPlacemark(coordinate: businessModel.coordinate, postalAddress: address.postalAddress)
      let mapItem = MKMapItem(businessModel: businessModel, placemark: placemark)
      
      mapItem.openInMaps(launchOptions: mapLaunchOptions)
    }
    else {
      // We don't have address info so lets get the information
      // TODO: Cache this value? Maybe not? Look into geocoding api
      let geocoder = CLGeocoder()
      let location = CLLocation(latitude: businessModel.coordinate.latitude,
                                longitude: businessModel.coordinate.longitude)

      // TODO: This is a network request, so we need a loading spinner here to
      // prevent user interaction while the request is in flight
      geocoder.reverseGeocodeLocation(location) { placemarks, error in
        let mkPlacemark: MKPlacemark
        if let placemark = placemarks?.first {
          mkPlacemark = MKPlacemark(placemark: placemark)
        }
        else {
          log(.error, for: LoggingDomain.general, message: "Error reverse geocoding: \(String(describing: error))")
          
          // If this fails we still have the coordinates, so lets just open the map without
          // address info
          mkPlacemark = MKPlacemark(coordinate: businessModel.coordinate)
        }
        let mapItem = MKMapItem(businessModel: businessModel, placemark: mkPlacemark)
        
        mapItem.openInMaps(launchOptions: mapLaunchOptions)
      }
    }
    
  }
  
  func discardOption(_ businessModel: BusinessModel?) {
    defer {
      viewController?.showNextOption()
    }
    guard let businessModel = businessModel else { return }

    print("Discarded \(businessModel.name)")
  }
}
