//
//  Assertion.swift
//  project-alpha
//
//  Created by Daniel Seitz on 12/15/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation

import YAPI

public func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
  YAPI.assert(condition, message, file: file, line: line)
}

public func assertionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
  YAPI.assertionFailure(message, file: file, line: line)
}
