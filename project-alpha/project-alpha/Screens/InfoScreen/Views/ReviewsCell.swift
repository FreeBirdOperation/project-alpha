//
//  ReviewsCell.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/29/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class ReviewsCell: PATableViewCell {
  // TODO: Make this a scroller to swipe through reviews
  let reviews: [ReviewModel]
  
  let reviewView: ReviewView
  
  // TEMP
  let label: PALabel
  
  init(reviews: [ReviewModel], reuseIdentifier: String) {
    self.reviews = reviews
    self.reviewView = ReviewView()
    self.label = PALabel()
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    
    setupView()
    if let review = reviews.first {
      var userImageDisplayModel: PAImageViewDisplayModel? = nil
      if let userImage = review.userImage {
        userImageDisplayModel = PAImageViewDisplayModel(imageReference: userImage)
      }
      let reviewLabelDisplayModel = PALabelDisplayModel(text: review.text)
      let reviewViewDisplayModel = ReviewViewDisplayModel(userImageDisplayModel: userImageDisplayModel,
                                                          reviewLabelDisplayModel: reviewLabelDisplayModel)
      
      reviewView.displayModel = reviewViewDisplayModel
    }
    
    if let text = reviews.first?.text {
      label.text = text
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    contentView.addSubview(reviewView)
    reviewView.autoPinEdgesToSuperviewMargins()
//    contentView.addSubview(label)
//    label.autoPinEdgesToSuperviewMargins()
//    label.numberOfLines = 0
//    label.lineBreakMode = .byWordWrapping
  }
}
