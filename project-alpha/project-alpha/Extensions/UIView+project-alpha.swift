//
//  UIView+project-alpha.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/20/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit

extension UIView {
  func isLeft(of other: UIView) -> Bool {
    return self.center.x < other.center.x
  }
  
  func isRight(of other: UIView) -> Bool {
    return !isLeft(of: other)
  }
  
  func offsetFrom(view: UIView) -> (x: CGFloat, y: CGFloat) {
    let x = fabs(self.center.x - view.center.x)
    let y = fabs(self.center.y - view.center.y)
    
    return (x: x, y: y)
  }
  
  func centerDistance(from edge: ViewEdge, of view: UIView) {
    
  }
}

enum ViewEdge {
  case left
  case right
  case top
  case bottom
}
