//
//  PAButton.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/25/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

typealias PAButtonActionBlock = () -> Void

class PAButton: UIButton {
  var actionBlock: PAButtonActionBlock?

  init(actionBlock: PAButtonActionBlock? = nil) {
    super.init(frame: CGRect.zero)
    
    self.addTarget(self, action: #selector(performActionBlock), for: .touchUpInside)
    
    self.actionBlock = actionBlock
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  private func performActionBlock() {
    actionBlock?()
  }
}
