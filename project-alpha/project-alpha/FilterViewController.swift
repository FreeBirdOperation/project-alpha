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
    // Properties
    @IBOutlet weak var distanceLabel: UITextField!
    let distanceFilter = ["5", "10", "15", "20", "50", "100"]
    let distancePicker = UIPickerView()
    
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
        if(distanceLabel.text != ""){
            performSegue(withIdentifier: "segueResult", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var result = segue.destination as! ResultViewController
        result.passedInfo = distanceLabel.text!
    }
    
}
