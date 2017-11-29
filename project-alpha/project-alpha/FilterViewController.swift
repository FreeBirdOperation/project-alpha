//
//  FilterViewController.swift
//  project-alpha
//
//  Created by Cher Moua on 11/15/17.
//  Copyright © 2017 freebird. All rights reserved.
//

//import Cocoa
import UIKit

// Global for testing, get rid of this (Replace with loading spinner or some progress indicator)
var inProgress: Bool = false

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  // Testing purposes only.
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
  // Properties
  @IBOutlet weak var distanceLabel: UITextField!
  let distanceFilter = ["5", "10", "15", "20", "50", "100"]
  let distancePicker = UIPickerView()
  
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
    
    distancePicker.delegate = self
    distancePicker.dataSource = self
    
    //Binding textfield to picker
    distanceLabel.inputView = distancePicker
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
      inProgress = true
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

          let resultVC = ResultViewController(networkAdapter: networkAdapter, searchParameters: params)
          self.navigationController?.pushViewController(resultVC, animated: true)
          inProgress = false
        }
      }
    }
  }
  
    /*
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    var result = segue.destination as! ResultViewController
  }*/
    
    func startIndicator(){
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.gray
        view.subviews(self.activityIndicator)
        self.activityIndicator.startAnimating()
        // when indicator begins the user can't interact with the app
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopIndicator(){
        self.activityIndicator.stopAnimating()
        // continue interaction
        UIApplication.shared.endIgnoringInteractionEvents()
    }
  
}
