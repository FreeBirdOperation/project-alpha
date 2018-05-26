//
//  PALabel.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/25/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class PALabel: UILabel {
  init(text: String) {
    super.init(frame: CGRect.zero)
    
    self.text = text
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
