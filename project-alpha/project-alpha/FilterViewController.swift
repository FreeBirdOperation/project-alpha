//
//  FilterViewController.swift
//  project-alpha
//
//  Created by Cher Moua on 11/15/17.
//  Copyright © 2017 freebird. All rights reserved.
//

//import Cocoa
import UIKit

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var distanceLabel: UITextField!
    let distanceFilter = ["5", "10", "15", "20", "50", "100"]
    let distancePicker = UIPickerView()
    
    override func viewDidLoad() {
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
}
