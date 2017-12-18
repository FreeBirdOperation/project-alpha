//
//  MockResultViewController.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/15/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
@testable import project_alpha

extension Mock.ResultScreen {
  static var viewController: ResultViewController { return ViewController() }
  
  private class ViewController: ResultViewController {
    fileprivate convenience init() {
      let pageModel = ResultViewControllerPageModel(delegate: Mock.ResultScreen.delegate, searchParameters: SearchParameters(distance: 10))
      
      self.init(pageModel: pageModel)
    }
  }
}
