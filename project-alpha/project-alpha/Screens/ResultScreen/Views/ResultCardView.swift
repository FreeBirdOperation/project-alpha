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

class ResultCardView: PAView, ResultDisplayable {
  var titleLabel: PALabel
  var imageView: ImageGalleryView
  var choiceImageView: UIImageView
  var categoryLabel: PALabel
  // TODO: Replace with dollar sign view
  var costLabel: PALabel
  // TODO: Replace with star view
  var ratingLabel: PALabel
  let blurFilterView: UIVisualEffectView
  let supplementaryContentContainer: PAView
  
  init(imageHeight: CGFloat) {
    self.titleLabel = PALabel()
    self.imageView = ImageGalleryView()
    self.choiceImageView = UIImageView()
    self.categoryLabel = PALabel()
    self.costLabel = PALabel()
    self.ratingLabel = PALabel()
    self.blurFilterView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    self.supplementaryContentContainer = PAView()

    super.init()

    self.addSubview(titleLabel)
    self.addSubview(imageView)
    imageView.backgroundColor = UIColor.black
    self.addSubview(choiceImageView)
    self.addSubview(categoryLabel)
    self.addSubview(costLabel)
    self.addSubview(ratingLabel)
    self.addSubview(blurFilterView)
    self.addSubview(supplementaryContentContainer)
    self.setupConstraints(with: imageHeight)
    self.setupBlur()
    
    self.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    self.layoutMarginsDidChange()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints(with imageHeight: CGFloat) {
    imageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    imageView.autoSetDimension(.height, toSize: imageHeight)
//    imageView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.33)
    imageView.contentMode = .scaleAspectFit
    
    titleLabel.autoPinEdge(toSuperviewMargin: .left)
    titleLabel.autoPinEdge(toSuperviewMargin: .right)
    titleLabel.autoPinEdge(.top, to: .bottom, of: imageView)
    titleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
    
    choiceImageView.autoCenterInSuperview()
    choiceImageView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.25)
    choiceImageView.autoMatch(.width, to: .height, of: self, withMultiplier: 0.25)
    
    categoryLabel.autoPinEdge(toSuperviewMargin: .left)
    categoryLabel.autoPinEdge(toSuperviewMargin: .right)
    categoryLabel.autoPinEdge(.top, to: .bottom, of: titleLabel)
    categoryLabel.numberOfLines = 0
    categoryLabel.lineBreakMode = .byWordWrapping
    
    costLabel.autoPinEdge(toSuperviewMargin: .left)
    costLabel.autoPinEdge(toSuperviewMargin: .right)
    costLabel.autoPinEdge(.top, to: .bottom, of: categoryLabel)

    ratingLabel.autoPinEdge(toSuperviewMargin: .left)
    ratingLabel.autoPinEdge(toSuperviewMargin: .right)
    ratingLabel.autoPinEdge(.top, to: .bottom, of: costLabel)
    
    supplementaryContentContainer.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
    supplementaryContentContainer.autoPinEdge(.top, to: .bottom, of: ratingLabel)
  }
  
  func setupBlur() {
    blurFilterView.autoPinEdgesToSuperviewEdges()
    
    blurFilterView.alpha = 0.9
    
    // Remove this to default to blurred, just using for testing for now
    blurFilterView.isHidden = true
  }
  
  // MARK: - Result Displayable Conformance
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
    categoryLabel.text = businessModel.businessCategories.map { $0.displayName }.joined(separator: ", ")
    
    if let price = businessModel.businessPrice {
      costLabel.text = String.init(repeating: "$", count: Int(price.value))
    }
    ratingLabel.text = String(repeating: "*", count: Int(businessModel.businessRating.value))

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
