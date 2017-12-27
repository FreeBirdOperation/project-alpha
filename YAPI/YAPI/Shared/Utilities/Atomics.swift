//
//  Atomics.swift
//  YAPI
//
//  Created by Daniel Seitz on 12/19/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

struct Atomic<T> {
  private var value: T
  private let lock: NSLock

  init(_ value: T) {
    self.value = value
    self.lock = NSLock()
  }
  
  mutating func set(_ value: T) {
    execute {
      self.value = value
    }
  }
  
  func get() -> T {
    return execute { return self.value }
  }
  
  mutating func swap(_ newValue: T) -> T {
    return execute {
      let oldValue = self.value
      self.value = newValue
      return oldValue
    }
  }
  
  mutating func update(updateBlock: (inout T) -> T) {
    execute {
      self.value = updateBlock(&self.value)
    }
  }
  
  private func execute<R>(block: () -> R) -> R {
    lock.lock()
    let result = block()
    lock.unlock()
    return result
  }
}

extension Atomic where T: Equatable {
  mutating func compareAndSwap(old: T, new: T) -> Bool {
    return execute {
      if self.value == old {
        self.value = new
        return true
      }
      return false
    }
  }
}
