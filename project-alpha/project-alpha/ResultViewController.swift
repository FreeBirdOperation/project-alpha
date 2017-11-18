//
//  ResultViewController.swift
//  project-alpha
//
//  Created by Cher Moua on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import MapKit

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
    var limit = 0
    var tracker = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = passedInfo
        limit = Int(label.text!)!
        randomDataGenerator(num: limit)
        displayInfo(position: tracker)
    }
    
    private func displayInfo(position: Int){
        self.nameLabel.text = dummyData[position].name
        self.priceLabel.text = String(dummyData[position].price)
        self.distanceLabel.text = String(dummyData[position].distance)
        self.numberLabel.text = String(dummyData[position].number)
    }
    
    private func randomDataGenerator(num: Int){
        for index in 0...num{
            dummyData.append(placeData(name: "Testing Restaurant", price: 4, distance: index+3, number: index))
        }
    }
    
    /*
    private func openMaps(placeName: String, latitude: Double, longitude: Double){
        self.view.backgroundColor = .blue
        let lat:CLLocationDegrees = latitude
        let long:CLLocationDegrees = longitude
        
        let regionDistance: CLLocationDistance = 1000; //?
        let cordinates = CLLocationCoordinate2DMake(lat, long)
        let regionSpan = MKCoordinateRegionMakeWithDistance(cordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: cordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }
    */
    
    // SWIPE FUNCTIONS
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        //self.view.backgroundColor = .blue
        
        // Keep for now. 
        let latitude:CLLocationDegrees = 45.533211
        let longitude:CLLocationDegrees = -122.847043
        
        let regionDistance: CLLocationDistance = 1000; //?
        let cordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(cordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: cordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Krispy Kreme Doughnuts"
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        self.view.backgroundColor = .yellow
        tracker += 1
        if(tracker < limit){
            displayInfo(position: tracker)
        }else{
            self.view.backgroundColor = .red
        }
    }

    @IBAction func upSwipe(_ sender: UISwipeGestureRecognizer) {
        self.view.backgroundColor = .green
    }
    
    //@IBAction func downSwipe(_ sender: UISwipeGestureRecognizer) {
    //    self.view.backgroundColor = .purple
    //}
}
