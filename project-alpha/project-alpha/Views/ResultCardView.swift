//
//  ResultCardView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/22/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import YAPI

class ResultCardView: UIView {
  var titleLabel: UILabel
  var imageView: UIImageView
  var choiceImageView: UIImageView
  
  private var _businessModel: BusinessModel?
  var businessModel: BusinessModel? {
    get {
      return _businessModel
    }
    set {
      guard let businessModel = newValue else {
        DispatchQueue.main.async {
          self.titleLabel.text = ""
          self.imageView.image = nil
          self._businessModel = nil
        }
        return
      }
      _businessModel = businessModel
      self.titleLabel.text = businessModel.name
      businessModel.imageReference?.load { [weak self] result in
        guard case .ok(let image) = result else {
          log(.error, for: .imageLoading, message: "Failed to load image: \(result.unwrapErr())")
          return
        }
        
        DispatchQueue.main.async {
          self?.imageView.image = image
        }
      }
    }
  }
  
  override init(frame: CGRect) {
    self.titleLabel = UILabel()
    self.imageView = UIImageView()
    self.choiceImageView = UIImageView()

    super.init(frame: frame)

    self.addSubview(titleLabel)
    self.addSubview(imageView)
    self.addSubview(choiceImageView)
    self.setupConstraints()
  }
  
  convenience init(businessModel: BusinessModel, frame: CGRect) {
    self.init(frame: frame)
    
    self.businessModel = businessModel
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
  }
}
