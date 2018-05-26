//
//  MapSearchViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/25/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import MapKit
import YAPI

class MapSearchViewController: PAViewController {
  let mapView: MKMapView
  let centerView: PAView
  let searchButton: PAButton
  
  let networkAdapter: NetworkAdapter
  
  init(currentLocation: CLLocation, networkAdapter: NetworkAdapter) {
    mapView = MKMapView(forAutoLayout: ())
    centerView = PAView()
    searchButton = PAButton()
    
    self.networkAdapter = networkAdapter
    
    super.init()
    
    centerMap(on: currentLocation, radius: 1000)

    mapView.delegate = self
    searchButton.actionBlock = { [weak self] in
      guard let strongSelf = self else { return }

      let location = CLLocation(coordinate: strongSelf.mapView.centerCoordinate)
      let distance = strongSelf.distanceForEdgeOfSearchRadius()
      let limit = 10
      let locale = PALocale.current
      let searchParameters = SearchParameters(location: location,
                                              distance: Int(distance),
                                              limit: limit,
                                              locale: locale)
      let pageModel = ResultViewControllerPageModel(delegate: ResultActionHandler(networkAdapter: strongSelf.networkAdapter),
                                                    infoViewControllerDelegate: InfoActionHandler(networkAdapter: strongSelf.networkAdapter),
                                                    searchParameters: searchParameters)
      
      let resultViewController = ResultViewController(pageModel: pageModel)
      strongSelf.navigationController?.pushViewController(resultViewController, animated: true)
    }
  }
  
  override func viewDidLoad() {
    setupMapView()
    setupCenterView()
    setupSearchButton()
  }
  
  func centerMap(on location: CLLocation, radius: CLLocationDistance) {
    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
    mapView.setRegion(region, animated: false)
  }
  
  private func setupMapView() {
    view.addSubview(mapView)
    mapView.autoPinEdgesToSuperviewEdges()
    mapView.showsUserLocation = true
  }
  
  private func setupCenterView() {
    view.addSubview(centerView)
    centerView.autoCenterInSuperview()
    let size = view.frame.width / 1.5
    centerView.autoSetDimensions(to: CGSize(width: size, height: size))
    centerView.layer.cornerRadius = size / 2
    
    centerView.layer.borderWidth = 1
    
    centerView.backgroundColor = UIColor.green
    centerView.alpha = 0.1
    centerView.isUserInteractionEnabled = false
  }
  
  private func setupSearchButton() {
    view.addSubview(searchButton)
    searchButton.autoPinEdge(toSuperviewMargin: .left)
    searchButton.autoPinEdge(toSuperviewMargin: .right)
    searchButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
    searchButton.backgroundColor = .red
    searchButton.setTitle(NSLocalizedString("Search", comment: ""), for: .normal)

    searchButton.layer.cornerRadius = 5
    searchButton.layer.masksToBounds = false
    searchButton.layer.borderWidth = 0.5
    
    // Setup drop shadow
    searchButton.layer.shadowColor = UIColor.black.cgColor
    searchButton.layer.shadowOpacity = 0.8
    searchButton.layer.shadowRadius = 5
    searchButton.layer.shadowOffset = CGSize(width: 0, height: 6)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func distanceForEdgeOfSearchRadius() -> CLLocationDistance {
    let x = centerView.center.x
    let y = centerView.frame.origin.y
    let edgeCoordinate = mapView.convert(CGPoint(x: x, y: y), toCoordinateFrom: centerView)
    let centerCoordinate = mapView.convert(centerView.center, toCoordinateFrom: centerView)

    return CLLocation.distance(from: centerCoordinate, to: edgeCoordinate)
  }
}

extension MapSearchViewController: MKMapViewDelegate {
}

extension CLLocation {
  
  /// Get distance between two points
  ///
  /// - Parameters:
  ///   - from: first point
  ///   - to: second point
  /// - Returns: the distance in meters
  class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
    let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
    return to.distance(from: from)
  }
  
  convenience init(coordinate: CLLocationCoordinate2D) {
    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}
