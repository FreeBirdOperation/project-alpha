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
  let networkAdapter: NetworkAdapter
  let businessModel: BusinessModel
}

protocol InfoViewControllerPageModel {
  var networkAdapter: NetworkAdapter { get }
  var businessModel: BusinessModel { get }
}

class InfoViewController: PAViewController {
  let scrollView = PAScrollView(forAutoLayout: ())
  lazy var mapButton = CallToActionButton(actionBlock: { [weak self] in
    guard let businessModel = self?.businessModel else { return }
    self?.delegate.openInMaps(businessModel)
  })
  lazy var infoView = InfoCardView(imageHeight: 200, actionDelegate: self.delegate)

  lazy var delegate = InfoActionHandler(networkAdapter: self.networkAdapter,
                                        viewController: self)
  private let businessModel: BusinessModel
  private let networkAdapter: NetworkAdapter

  init(pageModel: InfoViewControllerPageModel) {
    businessModel = pageModel.businessModel
    networkAdapter = pageModel.networkAdapter
    super.init()

    setupScrollView()
    setupMapButton()
    setupInfoView(with: businessModel)
    setupConstraints()

    view.backgroundColor = UIColor.green
    
    delegate.lookupBusiness(with: businessModel.id) { [weak self] result in
      guard let strongSelf = self else { return }

      guard case .ok(let businessModel) = result else {
        log(.error, for: .network, message: "Error looking up business \(strongSelf.businessModel.id): \(result.unwrapErr())")
        return
      }
      
      var newBusinessModel = MutableBusinessModel(businessModel: strongSelf.businessModel)
      newBusinessModel.imageReferences = businessModel.imageReferences
      newBusinessModel.reviews = businessModel.reviews
      
      DispatchQueue.main.async {
        strongSelf.infoView.display(businessModel: newBusinessModel)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupScrollView() {
    view.addSubview(scrollView)
    
    scrollView.isUserInteractionEnabled = true
    scrollView.isScrollEnabled = true
    scrollView.bounces = true
    scrollView.alwaysBounceVertical = true
    scrollView.alwaysBounceHorizontal = false
  }
  
  private func setupMapButton() {
    view.addSubview(mapButton)

    mapButton.backgroundColor = UIColor.cyan
    mapButton.setTitle("GO TO MAP", for: .normal)
  }
  
  private func setupInfoView(with businessModel: BusinessModel) {
    scrollView.addSubview(infoView)

    infoView.display(businessModel: businessModel)
  }
  
  private func setupConstraints() {
    // Scroll View
    scrollView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)

    // Map Button
    mapButton.autoPinEdge(.top, to: .bottom, of: scrollView)
    mapButton.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
  
    // Info View
    infoView.autoPinEdgesToSuperviewEdges()
    infoView.autoSetDimension(.width, toSize: view.frame.size.width)
  }
}

private extension UIView {
  func enableTouchForAllSubviews() {
    self.isUserInteractionEnabled = true
    for subview in subviews {
      subview.enableTouchForAllSubviews()
    }
  }
}
