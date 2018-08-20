//
//  WebsiteView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/29/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class WebsiteCell: PATableViewCell {
  let websiteView: WebsiteView
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?, actionBlock: CellActionBlock?) {
    websiteView = WebsiteView()
    super.init(style: style, reuseIdentifier: reuseIdentifier, actionBlock: actionBlock)
    
    contentView.addSubview(websiteView)
    websiteView.autoPinEdgesToSuperviewEdges()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class WebsiteView: PAView {
  let label: PALabel
  
  override init() {
    // TODO: Localize
    label = PALabel(text: "Website")
    super.init()
    
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
//    label.text = "Website"
    addSubview(label)
    label.autoPinEdgesToSuperviewMargins()
    label.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  override var intrinsicContentSize: CGSize {
    return label.intrinsicContentSize
  }
}
