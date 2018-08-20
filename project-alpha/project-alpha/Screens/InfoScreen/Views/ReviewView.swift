//
//  ReviewView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/30/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

struct ReviewViewDisplayModel {
  var userImageDisplayModel: PAImageViewDisplayModel?
  var reviewLabelDisplayModel: PALabelDisplayModel
  
  init(userImageDisplayModel: PAImageViewDisplayModel?, reviewLabelDisplayModel: PALabelDisplayModel) {
    self.userImageDisplayModel = userImageDisplayModel
    self.reviewLabelDisplayModel = reviewLabelDisplayModel
  }
  
  init(review: ReviewModel) {
    var userImageDisplayModel: PAImageViewDisplayModel? = nil
    if let userImage = review.userImage {
      userImageDisplayModel = PAImageViewDisplayModel(imageReference: userImage)
    }
    let reviewLabelDisplayModel = PALabelDisplayModel(text: review.text)

    self.init(userImageDisplayModel: userImageDisplayModel,
              reviewLabelDisplayModel: reviewLabelDisplayModel)
  }
}

class ReviewView: PAView {
  let userImage: PAImageView
  let reviewLabel: PALabel
  let bufferingOverlay: BufferingOverlay = BufferingOverlay(forAutoLayout: ())
  
  var displayModel: ReviewViewDisplayModel? {
    didSet {
      guard let displayModel = displayModel else {
        bufferingOverlay.isHidden = false
        return
      }
      
      bufferingOverlay.isHidden = true
      userImage.displayModel = displayModel.userImageDisplayModel
      reviewLabel.displayModel = displayModel.reviewLabelDisplayModel
    }
  }
  
  init(review: ReviewViewDisplayModel? = nil) {
    userImage = PAImageView()
    reviewLabel = PALabel()
    
    super.init()
    
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(userImage)
    addSubview(reviewLabel)
    
    userImage.autoPinEdge(toSuperviewMargin: .top)
    userImage.autoPinEdge(toSuperviewMargin: .left)
    userImage.autoSetDimensions(to: CGSize(width: 50, height: 50))
    userImage.contentMode = .scaleAspectFill
    userImage.layer.cornerRadius = 10
    userImage.layer.masksToBounds = true
    
    reviewLabel.autoPinEdge(.top, to: .bottom, of: userImage)
    reviewLabel.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
    reviewLabel.numberOfLines = 0
    reviewLabel.lineBreakMode = .byWordWrapping
    
    addSubview(bufferingOverlay)
    bufferingOverlay.autoPinEdgesToSuperviewEdges()
    NSLayoutConstraint.autoSetPriority(UILayoutPriority(249)) {
      bufferingOverlay.autoSetDimension(.height, toSize: 80)
    }
  }
}
