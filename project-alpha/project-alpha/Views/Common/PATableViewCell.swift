//
//  File.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/29/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class PATableViewCell: UITableViewCell {
  typealias CellActionBlock = () -> Void
  var actionBlock: CellActionBlock?
  
  static var placeholderCell: PATableViewCell {
    return PATableViewCell(style: .default, reuseIdentifier: "__PA__PlaceholderCell")
  }
  
  init(style: UITableViewCellStyle, reuseIdentifier: String?, actionBlock: CellActionBlock? = nil) {
    self.actionBlock = actionBlock
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
