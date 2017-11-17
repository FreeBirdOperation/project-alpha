//
//  ResultViewController.swift
//  project-alpha
//
//  Created by Cher Moua on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var passedInfo = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = passedInfo
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
    
    @IBAction func downSwipe(_ sender: UISwipeGestureRecognizer) {
        self.view.backgroundColor = .purple
    }
}
