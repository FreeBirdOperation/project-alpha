//
//  SwipeDirection.swift
//  project-alpha
//
//  Created by Daniel Seitz on 12/10/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation

enum SwipeDirection {
  case left
  case right
}

extension SwipeDirection {
  var isLeft: Bool {
    return self == .left
  }
  
  var isRight: Bool {
    return self == .right
  }
}
