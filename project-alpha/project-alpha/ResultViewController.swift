//
//  ResultViewController.swift
//  project-alpha
//
//  Created by Cher Moua on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit

struct placeData {
    var name: String
    var price: Int
    var distance: Int
    var number: Int
    
    init(name: String, price: Int, distance: Int, number: Int){
        self.name = name
        self.price = price
        self.distance = distance
        self.number = number
    }
}

class ResultViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var passedInfo = String()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var dummyData = [placeData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = passedInfo
        randomDataGenerator(num: Int(label.text!)!)
        
        
    }
    
    private func randomDataGenerator(num: Int){
        for index in 0...num{
            dummyData.append(placeData(name: "Testing Restaurant", price: 4, distance: index+3, number: index))
        }
    }
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        self.view.backgroundColor = .blue
    }
    
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        self.view.backgroundColor = .yellow
    }

    @IBAction func upSwipe(_ sender: UISwipeGestureRecognizer) {
        self.view.backgroundColor = .green
    }
    
    //@IBAction func downSwipe(_ sender: UISwipeGestureRecognizer) {
    //    self.view.backgroundColor = .purple
    //}
}
