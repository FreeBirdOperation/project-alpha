//
//  Collections+project-alpha.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/25/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation

extension MutableCollection {
  /// Shuffle the elements of `self` in-place.
  mutating func shuffle() {
    // empty and single-element collections don't shuffle
    if count < 2 { return }
    
    for i in indices.dropLast() {
      let diff = distance(from: i, to: endIndex)
      let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
      swapAt(i, j)
    }
  }
}

extension Collection {
  /// Return a copy of `self` with its elements shuffled
  func shuffled() -> [Element] {
    var list = Array(self)
    list.shuffle()
    return list
  }
  
  var second: Element? {
    return self.count > 1 ? self[index(startIndex, offsetBy: 1)] : nil
  }
}

extension Array {
  mutating func popFirst() -> Element? {
    return self.count > 1 ? self.removeFirst() : nil
  }
}
