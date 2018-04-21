//
//  PAImageView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/12/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

enum PAImageViewSource {
  case image(UIImage)
  case imageReference(ImageReference)
}

struct PAImageViewDisplayModel {
  var imageSource: PAImageViewSource
  
  init(imageSource: PAImageViewSource) {
    self.imageSource = imageSource
  }
  
  init(image: UIImage) {
    self.imageSource = .image(image)
  }
  
  init(imageReference: ImageReference) {
    self.imageSource = .imageReference(imageReference)
  }
}

class PAImageView: UIImageView {
  var displayModel: PAImageViewDisplayModel? {
    didSet {
      guard let displayModel = displayModel else {
        removeImage(showPlaceholder: false)
        return
      }
      
      switch displayModel.imageSource {
      case .image(let image):
        setupView(with: image)
      case .imageReference(let imageReference):
        setupView(with: imageReference)
      }
    }
  }
  
  private func setupView(with image: UIImage) {
    self.image = image
  }
  
  private func setupView(with imageReference: ImageReference) {
    // TODO: Set placeholder image for view
    // self.image = placeholder
    
    imageReference.load { [weak self] result in
      guard case .ok(let image) = result else {
        log(.error, for: .imageLoading, message: "Failed to load image: \(result.unwrapErr())")
        return
      }
      
      if !Thread.isMainThread {
        DispatchQueue.main.async {
          self?.image = image
        }
      }
      else {
        self?.image = image
      }
    }
  }
  
  private func removeImage(showPlaceholder: Bool) {
    // TODO: Set placeholder image for view
    if showPlaceholder {
      // self.image = placeholder
    }
    else {
      self.image = nil
    }
  }
}
