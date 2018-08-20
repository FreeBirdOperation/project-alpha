//
//  BufferingOverlay.swift
//  project-alpha
//
//  Created by Daniel Seitz on 6/2/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class BufferingOverlay: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.lightGray
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
