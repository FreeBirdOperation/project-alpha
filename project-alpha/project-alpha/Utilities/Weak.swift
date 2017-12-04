//
//  Weak.swift
//  project-alpha
//
//  Created by Daniel Seitz on 12/3/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation

struct Weak<T: AnyObject> {
  private(set) weak var value: T?
  
  init(_ value: T) {
    self.value = value
  }
}
