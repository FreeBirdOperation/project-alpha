//
//  ImageGalleryView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/12/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

struct ImageGalleryViewDisplayModel {
  var imageModels: [PAImageViewDisplayModel]
  var isUserInteractionEnabled: Bool = true
  
  init(imageModels: [PAImageViewDisplayModel]) {
    self.imageModels = imageModels
  }
}

class ImageGalleryView: PAView {
  private var _displayModel: ImageGalleryViewDisplayModel?
  var displayModel: ImageGalleryViewDisplayModel? {
    get {
      return _displayModel
    }
    set {
      guard let displayModel = newValue else {
        imageView.displayModel = nil
        return
      }
      
      _displayModel = displayModel

      // Prefetch any image references we have
      for imageModel in displayModel.imageModels {
        if case .imageReference(let imageReference) = imageModel.imageSource {
          imageReference.prefetch()
        }
      }
      currentIndex = 0
      imageView.displayModel = displayModel.imageModels.first
      
      pageControl.numberOfPages = displayModel.imageModels.count
      
      isUserInteractionEnabled = displayModel.isUserInteractionEnabled
    }
  }
  
  override var isUserInteractionEnabled: Bool {
    didSet {
      if isUserInteractionEnabled {
        pageControl.isHidden = false
        leftTapGestureRecognizer.isEnabled = true
        rightTapGestureRecognizer.isEnabled = true
      }
      else {
        pageControl.isHidden = true
        leftTapGestureRecognizer.isEnabled = false
        rightTapGestureRecognizer.isEnabled = false
      }
    }
  }
  
  let imageView: PAImageView
  let leftTapArea: PAView
  lazy var leftTapGestureRecognizer: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(showPreviousImage))
  }()
  let rightTapArea: PAView
  lazy var rightTapGestureRecognizer: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(showNextImage))
  }()
  let pageControl: UIPageControl
  private var currentIndex: Int {
    didSet {
      pageControl.currentPage = currentIndex
    }
  }
  
  override init() {
    self.imageView = PAImageView()
    self.leftTapArea = PAView()
    self.rightTapArea = PAView()
    self.pageControl = UIPageControl()
    self.currentIndex = 0
    super.init()

    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)
    imageView.autoPinEdgesToSuperviewEdges()
    
    addSubview(leftTapArea)
    leftTapArea.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .right)
    leftTapArea.autoMatch(.width, to: .width, of: self, withMultiplier: 0.5, relation: .equal)
    leftTapArea.addGestureRecognizer(leftTapGestureRecognizer)
    
    addSubview(rightTapArea)
    rightTapArea.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .left)
    rightTapArea.autoMatch(.width, to: .width, of: self, withMultiplier: 0.5, relation: .equal)
    rightTapArea.addGestureRecognizer(rightTapGestureRecognizer)
    
    addSubview(pageControl)
    pageControl.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func showNextImage() {
    guard
      let imageModels = displayModel?.imageModels,
      currentIndex < imageModels.count - 1
      else {
        return
    }
    
    currentIndex += 1
    imageView.displayModel = imageModels[currentIndex]
  }
  
  @objc func showPreviousImage() {
    guard
      let imageModels = displayModel?.imageModels,
      currentIndex > 0
      else {
        return
    }
    
    currentIndex -= 1
    imageView.displayModel = imageModels[currentIndex]
  }
}
