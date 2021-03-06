//
//  ResultCardView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/22/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import YAPI

class ResultCardViewModel {
  private let updateBlock: (BusinessModel?) -> Void
  var businessModel: BusinessModel? {
    didSet {
      updateBlock(businessModel)
    }
  }
  
  init(updateBlock: @escaping (BusinessModel?) -> Void) {
    self.updateBlock = updateBlock
  }
}

protocol ResultDisplayable {
  func display(businessModel: BusinessModel?)
  func startChoosing(direction: SwipeDirection)
  func fadeChoiceImage(to alpha: CGFloat)
  func blurImage()
  func unblurImage()
}

class ResultCardView: UIView {
  var titleLabel: UILabel
  var imageView: ImageGalleryView
  var choiceImageView: UIImageView
  let idLabel: UILabel
  let blurFilterView: UIVisualEffectView
  
  override init(frame: CGRect = CGRect.zero) {
    self.titleLabel = UILabel()
    self.imageView = ImageGalleryView()
    self.choiceImageView = UIImageView()
    self.idLabel = UILabel()
    self.blurFilterView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    super.init(frame: frame)

    self.addSubview(titleLabel)
    self.addSubview(imageView)
    self.addSubview(choiceImageView)
    self.addSubview(idLabel)
    self.addSubview(blurFilterView)
    self.setupConstraints()
    self.setupBlur()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
    titleLabel.autoPinEdges(toSuperviewMarginsExcludingEdge: .bottom)
    
    imageView.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
    imageView.autoPinEdge(.top, to: .bottom, of: titleLabel)
    imageView.contentMode = .scaleAspectFit
    
    choiceImageView.autoCenterInSuperview()
    choiceImageView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.25)
    choiceImageView.autoMatch(.width, to: .height, of: self, withMultiplier: 0.25)
    
    idLabel.autoPinEdge(toSuperviewMargin: .bottom)
    idLabel.autoAlignAxis(toSuperviewAxis: .vertical)
  }
  
  func setupBlur() {
    blurFilterView.autoPinEdgesToSuperviewEdges()
    
    blurFilterView.alpha = 0.9
    
    // Remove this to default to blurred, just using for testing for now
    blurFilterView.isHidden = true
  }
}

extension ResultCardView: ResultDisplayable {
  private static let leftChoiceImage = #imageLiteral(resourceName: "fork-and-knife")
  private static let rightChoiceImage = #imageLiteral(resourceName: "fork-and-plate")
  
  func display(businessModel: BusinessModel?) {
    guard let businessModel = businessModel else {
      isHidden = true
      titleLabel.text = ""
      imageView.displayModel = nil
      return
    }
    
    isHidden = false
    titleLabel.text = businessModel.name
    idLabel.text = businessModel.id
    if let imageReference = businessModel.imageReference {
      imageView.displayModel = ImageGalleryViewDisplayModel(imageModels: [PAImageViewDisplayModel(imageReference: imageReference)])
    }
  }
  
  func startChoosing(direction: SwipeDirection) {
    switch direction {
    case .left:
      choiceImageView.image = ResultCardView.leftChoiceImage
    case .right:
      choiceImageView.image = ResultCardView.rightChoiceImage
    }
  }
  
  func fadeChoiceImage(to alpha: CGFloat) {
    choiceImageView.alpha = alpha
  }
  
  func blurImage() {
    blurFilterView.isHidden = false
  }
  
  func unblurImage() {
    blurFilterView.isHidden = true
  }
}
