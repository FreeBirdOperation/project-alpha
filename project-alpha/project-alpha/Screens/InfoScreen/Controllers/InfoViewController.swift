//
//  InfoViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/19/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

struct InfoViewControllerPageModelObject: InfoViewControllerPageModel {
  let delegate: InfoViewControllerDelegate
  let businessModel: BusinessModel
}

protocol InfoViewControllerPageModel {
  var delegate: InfoViewControllerDelegate { get }
  var businessModel: BusinessModel { get }
}

class InfoViewController: PAViewController {
  let infoView: ResultCardView = ResultCardView()
  
  let delegate: InfoViewControllerDelegate
  let businessModel: BusinessModel
  init(pageModel: InfoViewControllerPageModel) {
    delegate = pageModel.delegate
    businessModel = pageModel.businessModel
    super.init()
    
    view.addSubview(infoView)
    infoView.autoPinEdgesToSuperviewEdges()
    infoView.display(businessModel: pageModel.businessModel)

    view.backgroundColor = UIColor.green
    
    delegate.lookupBusiness(with: LookupParameters(id: businessModel.id)) { [weak self] result in
      guard let strongSelf = self else { return }

      guard case .ok(let businessModel) = result else {
        log(.error, for: .network, message: "Error looking up business \(strongSelf.businessModel.id): \(result.unwrapErr())")
        return
      }
      
      var newBusinessModel = MutableBusinessModel(businessModel: strongSelf.businessModel)
      newBusinessModel.imageReferences = businessModel.imageReferences
      
      DispatchQueue.main.async {
        strongSelf.infoView.display(businessModel: newBusinessModel)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
