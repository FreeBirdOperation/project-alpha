//
//  FilterViewController.swift
//  project-alpha
//
//  Created by Cher Moua on 11/15/17.
//  Copyright © 2017 freebird. All rights reserved.
//

//import Cocoa
import UIKit
import CoreLocation
import YAPI
// Global for testing, get rid of this (Replace with loading spinner or some progress indicator)
var inProgress: Bool = false

class FilterViewController: UIViewController {
  // TODO: Inject this
  let locationManager: LocationManagerProtocol = LocationManager.sharedManager
  var networkAdaptor: Condition<NetworkAdapter> = Condition()
  var currentLocation: Condition<CLLocation> = Condition()
  
  // Testing purposes only.
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  // Properties
  @IBOutlet weak var distanceEntryField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.addObserver(self)
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    // Acitivity Indicator settings
    self.activityIndicator.center = self.view.center
    self.activityIndicator.hidesWhenStopped = true
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    view.addSubview(self.activityIndicator)
    
    // Map View Button
    let button = UIButton(forAutoLayout: ())
    button.titleLabel?.text = "To Map View"
    button.backgroundColor = UIColor.green
    view.addSubview(button)
    button.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
    button.addTarget(self, action: #selector(goToMapView), for: .touchUpInside)
    
    authenticate()
    setupTextField()
  }
  @objc func goToMapView() {
    let viewController = MapSearchViewController(currentLocation: currentLocation.wait(),
                                                 networkAdapter: networkAdaptor.wait())
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  private func authenticate(numRetries: Int = 3) {
    guard numRetries > 0 else {
      // TODO: Error handling, try different service? Pop up error message?
      print("Authentication failure, max retries reached")
      return
    }
    let authToken: YelpV3AuthenticationToken = YelpV3AuthenticationToken.token
    
    YelpV3Authenticator.authenticate(with: authToken) { [weak self] result in
      switch result {
      case .err(let error):
        print("Error authenticating: \(error)")
        self?.authenticate(numRetries: numRetries - 1)
        return
      case .ok(let networkAdaptor):
        self?.networkAdaptor.broadcast(value: networkAdaptor)
      }
    }
  }
  
  private func setupTextField() {
    distanceEntryField.placeholder = "Miles"
    distanceEntryField.keyboardType = .numberPad
    distanceEntryField.delegate = self
  }
  
  // action function for select button
  @IBAction func selectButton(_ sender: Any) {
    if !inProgress {
      startIndicator()
      let networkAdapter = networkAdaptor.wait()
      let location: CLLocation = currentLocation.wait()
      stopIndicator()

      let params = SearchParameters(location: location, distance: (Int(self.distanceEntryField.text ?? "") ?? 10) * 100, limit: 10)
      let pageModel = ResultViewControllerPageModel(delegate: ResultActionHandler(networkAdapter: networkAdapter),
                                                    infoViewControllerDelegate: InfoActionHandler(networkAdapter: networkAdapter),
                                                    searchParameters: params)
      
      let resultVC = ResultViewController(pageModel: pageModel)
      self.navigationController?.pushViewController(resultVC, animated: true)
    }
  }
  
  func startIndicator(){
    inProgress = true
    self.activityIndicator.startAnimating()
    view.isUserInteractionEnabled = false
  }
  
  func stopIndicator(){
    inProgress = false
    self.activityIndicator.stopAnimating()
    view.isUserInteractionEnabled = true
  }
  
}

extension FilterViewController: NetworkObserver {
  func loadBegan() {
    startIndicator()
  }
  
  func loadEnded() {
    stopIndicator()
  }
}

extension FilterViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    
    currentLocation.broadcast(value: location)
  }
}

extension FilterViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
  }
}
