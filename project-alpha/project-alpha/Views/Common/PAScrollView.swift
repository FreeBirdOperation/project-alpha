//
//  PAScrollView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 6/4/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class PAScrollView: UIScrollView {
  override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
    return super.touchesShouldBegin(touches, with: event, in: view)
  }
}
