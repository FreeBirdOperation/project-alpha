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
  let titleLabel: UILabel
  let imageView: UIImageView
  let choiceImageView: UIImageView
  
  init(businessModel: BusinessModel, frame: CGRect) {
    self.titleLabel = UILabel()
    self.titleLabel.text = businessModel.name
    self.imageView = UIImageView()
    self.choiceImageView = UIImageView()

    super.init(frame: frame)
    self.addSubview(titleLabel)
    self.addSubview(imageView)
    self.addSubview(choiceImageView)
    self.setupConstraints()
    
    businessModel.imageReference?.load { [weak self] result in
      guard case .ok(let image) = result else {
        log(.error, for: .imageLoading, message: "Failed to load image: \(result.unwrapErr())")
        return
      }
      
      self?.imageView.image = image
    }
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
