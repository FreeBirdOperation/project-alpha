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

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  // TODO: Inject this
  let locationManager: LocationManagerProtocol = LocationManager.sharedManager
  var networkAdaptor: Condition<NetworkAdapter> = Condition()
  var currentLocation: Condition<CLLocation> = Condition()
  
  // Testing purposes only.
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  // Properties
  @IBOutlet weak var distanceLabel: UITextField!
  let distanceFilter = ["5", "10", "15", "20", "50", "100"]
  let distancePicker = UIPickerView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.addObserver(self)
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    distancePicker.delegate = self
    distancePicker.dataSource = self
    
    //Binding textfield to picker
    distanceLabel.inputView = distancePicker
    
    // Acitivity Indicator settings
    self.activityIndicator.center = self.view.center
    self.activityIndicator.hidesWhenStopped = true
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    view.addSubview(self.activityIndicator)
    
    authenticate()
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
  
  @objc func photoButtonPressed() {
    let dataSource = PhotoViewerDataSourceModel(transitionStyle: .scroll,
                                                images: [PAImageViewDisplayModel(image: #imageLiteral(resourceName: "fork-and-knife")),
                                                         PAImageViewDisplayModel(image: #imageLiteral(resourceName: "fork-and-plate"))])
    let photoViewer = PhotoViewerViewController(dataSource: dataSource)
    navigationController?.pushViewController(photoViewer, animated: true)
  }
  
  
  // These next four functions are for UIPickerViewDelegate and UIPickerViewDataSource
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return distanceFilter[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return distanceFilter.count
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    distanceLabel.text = distanceFilter[row]
    self.view.endEditing(false)
  }
  
  // action function for select button
  @IBAction func selectButton(_ sender: Any) {
    if !inProgress {
      startIndicator()
      let networkAdapter = networkAdaptor.wait()
      let location: CLLocation = currentLocation.wait()
      stopIndicator()

      let params = SearchParameters(location: location, distance: (Int(self.distanceLabel.text ?? "") ?? 10) * 100)
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
