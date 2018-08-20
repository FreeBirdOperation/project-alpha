//
//  PALabel.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/25/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

struct PALabelDisplayModel {
  var text: String
}

class PALabel: UILabel {
  private var _displayModel: PALabelDisplayModel? = nil
  var displayModel: PALabelDisplayModel? {
    get {
      return _displayModel
    }
    set {
      _displayModel = newValue
      text = newValue?.text
    }
  }

  init(displayModel: PALabelDisplayModel? = nil) {
    super.init(frame: CGRect.zero)
    
    self.displayModel = displayModel
  }

  convenience init(text: String) {
    self.init(displayModel: PALabelDisplayModel(text: text))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
