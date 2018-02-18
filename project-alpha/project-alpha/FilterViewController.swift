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
// Global for testing, get rid of this (Replace with loading spinner or some progress indicator)
var inProgress: Bool = false

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
  // TODO: Inject this
  let locationManager: LocationManagerProtocol = LocationManager.sharedManager
  
  // Testing purposes only.
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  // Properties
  @IBOutlet weak var distanceLabel: UITextField!
  let distanceFilter = ["5", "10", "15", "20", "50", "100"]
  let distancePicker = UIPickerView()
  
  //NEW
  @IBOutlet weak var distanceTextField: UITextField!
  
  private func getKeys() -> [String: String] {
    guard
      let path = Bundle.main.path(forResource: "secrets", ofType: "plist"),
      let keys = NSDictionary(contentsOfFile: path) as? [String: String]
      else {
        assertionFailure("Unable to load secrets property list, contact dnseitz@gmail.com if you need the file")
        return [:]
    }
    return keys
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //NEW
    distanceTextField.keyboardType = UIKeyboardType.numberPad
    distanceTextField.delegate = self
    
    locationManager.requestWhenInUseAuthorization()
    
    distancePicker.delegate = self
    distancePicker.dataSource = self
    
    //Binding textfield to picker
    distanceLabel.inputView = distancePicker
    
    // Acitivity Indicator settings
    self.activityIndicator.center = self.view.center
    self.activityIndicator.hidesWhenStopped = true
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    view.addSubview(self.activityIndicator)
    
    let button = UIButton(forAutoLayout: ())
    button.backgroundColor = UIColor.red
    button.setTitle("Photo Viewer", for: .normal)
    button.addTarget(self, action: #selector(photoButtonPressed), for: .touchUpInside)
    
    view.addSubview(button)
    button.autoPinEdge(toSuperviewMargin: .bottom)
    button.autoAlignAxis(toSuperviewAxis: .vertical)
    button.autoPinEdge(toSuperviewMargin: .left)
  }
  
  @objc func photoButtonPressed() {
    let dataSource = PhotoViewerDataSourceModel(transitionStyle: .scroll,
                                                images: [PAImageViewDisplayModel(image: #imageLiteral(resourceName: "fork-and-knife")),
                                                         PAImageViewDisplayModel(image: #imageLiteral(resourceName: "fork-and-plate"))])
    let photoViewer = PhotoViewerViewController(dataSource: dataSource)
    navigationController?.pushViewController(photoViewer, animated: true)
  }
  
  //NEW
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    distanceTextField.resignFirstResponder()
    return true
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
    /*
     if(distanceLabel.text != ""){
     performSegue(withIdentifier: "segueResult", sender: self)
     }
     */
    if !inProgress {
      startIndicator()
      let keys = getKeys()
      guard
        let appId = keys["APP_ID"],
        let clientSecret = keys["CLIENT_SECRET"]
        else {
          assertionFailure("Unable to retrieve appId or clientSecret from file")
          return
      }
      let authToken = YelpV3AuthenticationToken(appId: appId, clientSecret: clientSecret)
      
      // TODO: Authenticate on app launch, not button press
      YelpV3Authenticator.authenticate(with: authToken) { result in
        guard case .ok(let networkAdapter) = result else {
          print("Error authenticating: \(result.unwrapErr())")
          return
        }

        DispatchQueue.main.async {
          let params = SearchParameters(distance: (Int(self.distanceLabel.text ?? "") ?? 10) * 100)
          let pageModel = ResultViewControllerPageModel(delegate: ResultActionHandler(networkAdapter: networkAdapter),
                                                        searchParameters: params)

          let resultVC = ResultViewController(pageModel: pageModel)
          self.navigationController?.pushViewController(resultVC, animated: true)
          self.stopIndicator()
        }
      }
    }
  }
  
    /*
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    var result = segue.destination as! ResultViewController
  }*/
    
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
