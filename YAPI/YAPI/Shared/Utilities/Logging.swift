//
//  Logging.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/15/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

var systemLoggers: [Logger] = [ConsoleLogger()]

func log(_ severity: Severity, message: String) {
  for logger in systemLoggers {
    logger.log(severity, message)
  }
}

protocol Logger {
  func log(_ severity: Severity, _ message: String)
}

public enum Severity {
  case success
  case info
  case warning
  case error
}

extension Severity: CustomStringConvertible {
  public var description: String {
    switch self {
    case .success: return "SUCCESS"
    case .info: return "INFO"
    case .warning: return "WARNING"
    case .error: return "ERROR"
    }
  }
}

struct ConsoleLogger: Logger {
  func log(_ severity: Severity, _ message: String) {
    print("[\(severity.description)]: \(message)")
  }
}
