//
//  PATableView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/28/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class PATableView: UITableView {
  var maxHeight: CGFloat = UIScreen.main.bounds.size.height
  
  override func reloadData() {
    super.reloadData()
    self.layoutIfNeeded()
    self.invalidateIntrinsicContentSize()
  }
  
  override var intrinsicContentSize: CGSize {
    let height = min(contentSize.height, maxHeight)
    return CGSize(width: contentSize.width, height: height)
  }
}
