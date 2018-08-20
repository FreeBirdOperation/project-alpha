//
//  NoResultsFoundViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 8/19/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class NoResultsFoundViewController: PAViewController {
  let label: PALabel
  let backButton: PAButton
  
  init(popToViewController: PAViewController) {
    label = PALabel()
    backButton = PAButton()
    
    super.init()
    
    view.addSubview(label)
    view.addSubview(backButton)
    
    label.autoCenterInSuperview()
    backButton.autoPinEdge(.top, to: .bottom, of: label)
    backButton.autoAlignAxis(toSuperviewAxis: .vertical)
    
    label.displayModel = PALabelDisplayModel(text: "No results found!")
    backButton.setTitle("Back to Map", for: .normal)
    backButton.actionBlock = {
      self.navigationController?.popToViewController(popToViewController, animated: true)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
