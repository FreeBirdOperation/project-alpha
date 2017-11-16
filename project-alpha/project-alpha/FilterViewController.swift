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
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pickerLabelView: UIPickerView!
    
    let distanceFilter = ["5", "10", "15", "20", "50", "100"]
    
    override func viewDidLoad() {
        pickerLabelView.isHidden = true
    }
    
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
        pickerView.isHidden = true
    }
}
