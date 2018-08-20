//
//  InfoActionHandler.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/19/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI
import MapKit

protocol InfoViewControllerDelegate: WebViewLauncher {
  func lookupBusiness(with id: String,
                      completionHandler: @escaping (Result<BusinessModel, [APIError]>) -> Void)
  func openInMaps(_ businessModel: BusinessModel)
}

private class CacheableBusinessModel: Cacheable {
  let businessModel: BusinessModel
  let isCacheable: Bool = true
  let cacheKey: CacheKey
  init(businessModel: BusinessModel) {
    self.businessModel = businessModel
    self.cacheKey = CacheKey(businessModel.id)
  }
}

class InfoActionHandler: InfoViewControllerDelegate {
  let networkAdapter: NetworkAdapter
  weak var viewController: UIViewController?
  private static let lookupResultsCache: Cache<CacheableBusinessModel> = Cache(identifier: "LookupResultsCache")
  
  init(networkAdapter: NetworkAdapter, viewController: UIViewController) {
    self.networkAdapter = networkAdapter
    self.viewController = viewController
  }

  func lookupBusiness(with id: String, completionHandler: @escaping (Result<BusinessModel, [APIError]>) -> Void) {
    
    let cacheKey = CacheKey(id)
    if let businessModel = InfoActionHandler.lookupResultsCache[cacheKey] {
      completionHandler(.ok(businessModel.businessModel))
    }
    else {
      let lookupParams = LookupParameters(id: id, locale: PALocale.current)
      let reviewParams = ReviewParameters(id: id, locale: PALocale.current)
      networkAdapter.coalesceRequests(with: [lookupParams, reviewParams]) { results in
        // FIXME: We probably only need one of them to get partial information
        guard
          let lookupResult = results.first(where: { $0 is LookupResult }) as? LookupResult,
          let reviewResult = results.first(where: { $0 is ReviewResult }) as? ReviewResult
          else {
            log(.warning, for: .network, message: "Failed to get proper results for business lookup")
            return
        }
        guard
          case .ok(let businessModel) = lookupResult,
          case .ok(let reviews) = reviewResult
          else {
            let lookupError = lookupResult.intoErr()
            let reviewError = reviewResult.intoErr()
            return completionHandler(.err([lookupError, reviewError].compactMap { $0 }))
        }
        
        var mutableBusinessModel = MutableBusinessModel(businessModel: businessModel)
        mutableBusinessModel.reviews = reviews
        let cacheableBusinessModel = CacheableBusinessModel(businessModel: mutableBusinessModel)
        InfoActionHandler.lookupResultsCache.insert(cacheableBusinessModel)
        
        completionHandler(.ok(mutableBusinessModel))
      }
    }
  }
  
  func openInMaps(_ businessModel: BusinessModel) {
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
}

extension InfoActionHandler: WebViewLauncher {
  func launchURL(_ url: URL) {
    guard let viewController = viewController else {
      return
    }
    
    let webViewController = WebViewController()
    let navigationController = UINavigationController(rootViewController: webViewController)
    navigationController.modalTransitionStyle = .coverVertical
    viewController.present(navigationController, animated: true) {
      webViewController.navigate(to: url)
    }
  }
}
