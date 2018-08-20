//
//  CallToActionButton.swift
//  project-alpha
//
//  Created by Daniel Seitz on 6/4/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class CallToActionButton: PAButton {
  override init(actionBlock: PAButtonActionBlock? = nil) {
    super.init(actionBlock: actionBlock)
    
    layer.cornerRadius = 5
    layer.masksToBounds = false
    layer.borderWidth = 0.5
    
    // Setup drop shadow
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 5
    layer.shadowOffset = CGSize(width: 0, height: 6)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
