//
//  PopAnimator.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/19/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  let duration = 0.5;
  var presenting = true;
  var originFrame = CGRect.zero;
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.duration;
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView;
    let toView = transitionContext.view(forKey: .to)!;
    let toAnimate = self.presenting ? toView : transitionContext.view(forKey: .from)!;
    let initialFrame = self.presenting ? self.originFrame : toAnimate.frame;
    let finalFrame = self.presenting ? toAnimate.frame : self.originFrame;
    
    let xScaleFactor = self.presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width;
    let yScaleFactor = self.presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height;
    
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor);
    
    if self.presenting {
      toAnimate.transform = scaleTransform;
      toAnimate.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
      toAnimate.clipsToBounds = true;
    }
    
    containerView.addSubview(toView);
    containerView.bringSubview(toFront: toAnimate);
    
    UIView.animate(withDuration: self.duration,
                   delay: 0.0,
                   options: [],
                   animations: {
                    toAnimate.transform = self.presenting ? CGAffineTransform.identity : scaleTransform;
                    toAnimate.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY);
    }, completion: {_ in
      transitionContext.completeTransition(true);
    });
  }
}

extension PopAnimator: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    self.presenting = true;
    return self;
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    self.presenting = false;
    return self;
  }
}

