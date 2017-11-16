//
//  Logging.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/15/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

var systemLoggers: [Logger] = [ConsoleLogger()]

func log(_ severity: LoggingSeverity, for domain: LoggingDomain = .general, message: String) {
  for logger in systemLoggers {
    logger.log(severity, for: domain, message)
  }
}

protocol Logger {
  func log( _ severity: LoggingSeverity, for domain: LoggingDomain, _ message: String)
}

public enum LoggingSeverity {
  case success
  case info
  case warning
  case error
}

public enum LoggingDomain {
  case general
  case network
}

extension LoggingSeverity: CustomStringConvertible {
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
  func log(_ severity: LoggingSeverity, for domain: LoggingDomain, _ message: String) {
    print("[\(severity.description)]: \(message)")
  }
}
