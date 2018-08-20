//
//  InfoCardView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/26/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

protocol WebViewLauncher {
  func launchURL(_ url: URL)
}

class InfoCardView: ResultCardView {
//  let reviewView: ReviewView
  let reviewCarousel: CarouselView
  let websiteView: WebsiteView
  let actionDelegate: WebViewLauncher
  private var cells: [UITableViewCell] = []
  
  init(imageHeight: CGFloat, actionDelegate: WebViewLauncher) {
//    reviewView = ReviewView()
    reviewCarousel = CarouselView()
    websiteView = WebsiteView()
    self.actionDelegate = actionDelegate
    super.init(imageHeight: imageHeight)
    
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    reviewCarousel.backgroundColor = .clear
//    supplementaryContentContainer.addSubview(reviewView)
    supplementaryContentContainer.addSubview(reviewCarousel)
    supplementaryContentContainer.addSubview(websiteView)
    
//    reviewView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    reviewCarousel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
    reviewCarousel.autoSetDimension(.height, toSize: 300.0)
    
//    websiteView.autoPinEdge(.top, to: .bottom, of: reviewView)
    websiteView.autoPinEdge(.top, to: .bottom, of: reviewCarousel)
    websiteView.autoPinEdge(toSuperviewEdge: .left)
    websiteView.autoPinEdge(toSuperviewEdge: .right)
    websiteView.autoPinEdge(toSuperviewEdge: .bottom)
  }

  override func display(businessModel: BusinessModel?) {
    super.display(businessModel: businessModel)
    
    guard let businessModel = businessModel else {
      // TODO: Nil screen
      return
    }
    let reviewViews = businessModel.reviews.map { review -> PAView in
      let reviewView = ReviewView()
      reviewView.translatesAutoresizingMaskIntoConstraints = true
      let displayModel = ReviewViewDisplayModel(review: review)
      reviewView.displayModel = displayModel
      return reviewView
    }
    let carouselModel = CarouselViewModel()
    carouselModel.carouselViews = reviewViews
    reviewCarousel.displayModel = carouselModel
//    reviewCarousel.addViews(reviewViews)
//    if let review = businessModel?.reviews.first {
//      reviewView.displayModel = ReviewViewDisplayModel(review: review)
//    }

    if let url = businessModel.url {
      websiteView.tapAction = { [actionDelegate] in
        actionDelegate.launchURL(url)
      }
    }
    else {
      websiteView.tapAction = nil
    }
    
    // TEST
//    let label = PALabel(text: "TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST ")
//    supplementaryContentContainer.addSubview(label)
//    label.numberOfLines = 0
//    label.lineBreakMode = .byWordWrapping
//    label.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
//    label.autoPinEdge(.top, to: .bottom, of: websiteView)
  }
}
