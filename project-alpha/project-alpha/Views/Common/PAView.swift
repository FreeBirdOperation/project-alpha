//
//  PAView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/12/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class PAView: UIView {
  private var tapGesture: UITapGestureRecognizer? = nil
  var tapAction: (() -> Void)? = nil {
    willSet {
      guard self.tapGesture == nil else { return }
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTargetAction))
      addGestureRecognizer(tapGesture)
      self.tapGesture = tapGesture
    }
  }
  
  @objc
  private func tapTargetAction() {
    tapAction?()
  }
  
  init() {
    super.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
