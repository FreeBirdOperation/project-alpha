//
//  PhotoViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/12/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class PhotoViewController: PAViewController {
  let imageView: PAImageView
  
  init(imageDisplayModel: PAImageViewDisplayModel) {
    self.imageView = PAImageView(forAutoLayout: ())
    self.imageView.displayModel = imageDisplayModel
    self.imageView.contentMode = .center
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(imageView)
    imageView.autoPinEdgesToSuperviewEdges()
  }
}
