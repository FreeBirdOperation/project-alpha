//
//  Mock.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/3/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation

@testable import project_alpha

private struct MockError: Error {}

enum Mock {
  static var error: Error { return MockError() }
}
