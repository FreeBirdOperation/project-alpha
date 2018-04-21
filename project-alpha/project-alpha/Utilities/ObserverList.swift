//
//  ObserverList.swift
//  project-alpha
//
//  Created by Daniel Seitz on 4/21/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

// Lookout for performance hits here, we're doing a lot of redundant
// work. It shouldn't be too bad though since there probably won't be
// many observers for these lists.

struct ObserverList<ObserverType: AnyObject> {
  private var _observers: Atomic<[Weak<ObserverType>]> = Atomic([])
  private(set) var observers: [ObserverType] {
    get {
      return _observers.get().flatMap { $0.value }
    }
    set {
      _observers.set(newValue.map { Weak($0) })
    }
  }
  
  private mutating func update(_ updateBlock: (inout [ObserverType]) -> Void) {
    _observers.update { observers in
      var updatedObservers = observers.flatMap { $0.value }
      updateBlock(&updatedObservers)
      return updatedObservers.map { Weak($0) }
    }
  }

  func contains(observer: ObserverType) -> Bool {
    return observers.contains { $0 === observer }
  }
  
  mutating func addObserver(_ observer: ObserverType) {
    update { observers in
      guard observers.contains(where: { $0 === observer }) else { return }
      observers.append(observer)
    }
  }
  
  mutating func removeObserver(_ observer: ObserverType) {
    update { observers in
      guard let index = observers.index(where: { $0 === observer }) else { return }
      observers.remove(at: index)
    }
  }
  
  func notifyObservers(notificationBlock: (ObserverType) -> Void) {
    for observer in observers {
      notificationBlock(observer)
    }
  }
}
