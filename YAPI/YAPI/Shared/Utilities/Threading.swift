//
//  Threading.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/30/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

class Condition<Signaled> {
  private let condition: NSCondition = NSCondition()
  private var value: Signaled?
  
  @discardableResult
  func wait() -> Signaled {
    condition.lock()
    defer {
      condition.unlock()
    }
    
    while true {
      guard let value = value else {
        condition.wait()
        continue
      }
      
      return value
    }
  }
  
  func broadcast(value: Signaled) {
    condition.lock()
    defer {
      condition.unlock()
    }
    
    self.value = value
    condition.broadcast()
  }
}
