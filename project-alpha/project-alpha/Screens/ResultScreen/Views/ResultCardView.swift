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

struct ResultCardViewDisplayModel {
  
}

protocol ResultDisplayable {
  func display(businessModel: BusinessModel?)
  func startChoosing(direction: SwipeDirection)
  func fadeChoiceImage(to alpha: CGFloat)
  func blurImage()
  func unblurImage()
}

class ResultCardView: PAView {
  var titleLabel: UILabel
  var imageView: ImageGalleryView
  var choiceImageView: UIImageView
  var categoryLabel: UILabel
  let blurFilterView: UIVisualEffectView
  
  override init() {
    self.titleLabel = UILabel()
    self.imageView = ImageGalleryView()
    self.choiceImageView = UIImageView()
    self.categoryLabel = UILabel()
    self.blurFilterView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    super.init()

    self.addSubview(titleLabel)
    self.addSubview(imageView)
    imageView.backgroundColor = UIColor.black
    self.addSubview(choiceImageView)
    self.addSubview(categoryLabel)
    self.addSubview(blurFilterView)
    self.setupConstraints()
    self.setupBlur()
    
    self.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    self.layoutMarginsDidChange()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    imageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    imageView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.33)
    imageView.contentMode = .scaleAspectFit
    
    titleLabel.autoPinEdge(toSuperviewMargin: .left)
    titleLabel.autoPinEdge(toSuperviewMargin: .right)
    titleLabel.autoPinEdge(.top, to: .bottom, of: imageView)
    titleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
    
    choiceImageView.autoCenterInSuperview()
    choiceImageView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.25)
    choiceImageView.autoMatch(.width, to: .height, of: self, withMultiplier: 0.25)
    
    categoryLabel.autoPinEdge(toSuperviewMargin: .left)
    categoryLabel.autoPinEdge(toSuperviewMargin: .left)
    categoryLabel.autoPinEdge(.top, to: .bottom, of: titleLabel)
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
    categoryLabel.text = businessModel.businessCategories.joined(separator: ", ")

    var displayModel = ImageGalleryViewDisplayModel(imageModels: businessModel.imageReferences.map { PAImageViewDisplayModel(imageReference: $0) })
    if businessModel.imageReferences.count <= 1 {
      displayModel.isUserInteractionEnabled = false
    }
    imageView.displayModel = displayModel
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
