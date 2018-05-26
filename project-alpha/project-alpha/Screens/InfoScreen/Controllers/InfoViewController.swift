//
//  InfoViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/19/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

struct InfoViewControllerPageModelObject: InfoViewControllerPageModel {
  let delegate: InfoViewControllerDelegate
  let businessModel: BusinessModel
}

protocol InfoViewControllerPageModel {
  var delegate: InfoViewControllerDelegate { get }
  var businessModel: BusinessModel { get }
}

class InfoViewController: PAViewController {
  let infoView: ResultCardView = ResultCardView()
  
  let delegate: InfoViewControllerDelegate
  let businessModel: BusinessModel
  lazy var dismissSwipeGesture: UISwipeGestureRecognizer = {
    let gestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                     action: #selector(swipeHandler(_:)))
    gestureRecognizer.direction = .down
    return gestureRecognizer
  }()
  lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                         action: #selector(handlePan(_:)))
  
  private var originalCenter: CGPoint = CGPoint.zero
  private var originalFrame: CGRect = CGRect.zero
  init(pageModel: InfoViewControllerPageModel) {
    delegate = pageModel.delegate
    businessModel = pageModel.businessModel
    super.init()
    
    dismissSwipeGesture.delegate = self
    panGestureRecognizer.delegate = self
    
    view.addSubview(infoView)
    view.addGestureRecognizer(dismissSwipeGesture)
    view.addGestureRecognizer(panGestureRecognizer)
    infoView.autoPinEdgesToSuperviewEdges()
    infoView.display(businessModel: pageModel.businessModel)

    view.backgroundColor = UIColor.green
    
    delegate.lookupBusiness(with: LookupParameters(id: businessModel.id)) { [weak self] result in
      guard let strongSelf = self else { return }

      guard case .ok(let businessModel) = result else {
        log(.error, for: .network, message: "Error looking up business \(strongSelf.businessModel.id): \(result.unwrapErr())")
        return
      }
      
      var newBusinessModel = MutableBusinessModel(businessModel: strongSelf.businessModel)
      newBusinessModel.imageReferences = businessModel.imageReferences
      
      DispatchQueue.main.async {
        strongSelf.infoView.display(businessModel: newBusinessModel)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    originalCenter = view.center
    originalFrame = view.frame
  }
  
  @objc func swipeHandler(_ gesture: UISwipeGestureRecognizer) {
//    if gesture.state == .ended {
//    switch gesture.direction {
//    case .down:
//      presentingViewController?.dismiss(animated: true, completion: nil)
//    default:
//      return
//    }
//    }
  }
  
  @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    guard let card = gesture.view else {
      assertionFailure("Gesture recognizer view should not be nil")
      return
    }

    let point = gesture.translation(in: view)
    card.center = CGPoint(x: originalCenter.x + point.x, y: originalCenter.y + point.y)
    scale(card: card)

    switch gesture.state {
    case .ended:
      gestureDidEnd(gesture)
    default:
      break
    }
  }
  
  private func scale(card: UIView) {
//    let longestSideLength = (originalFrame.height * originalFrame.height) + (originalFrame.width * originalFrame.width)
//    let minScale: CGFloat = 0.5
//    let xOffset = card.center.x - originalCenter.x
//    let yOffset = card.center.y - originalCenter.y
//    let distanceSquared = (xOffset * xOffset) + (yOffset * yOffset)
//
//    let scaleFactor = distanceSquared / longestSideLength
//    // Assuming width or height (longest side) of 100 points:
//    // 100 / 2 = 50 (half height of screen is range we want to scale over)
//    // 50 / maxScale = divisor (divisor is some value we can use to
//    //                                      backwards compute the desired rotation
//    //                                      based on distance from center)
//    // finalRotation = xOffset / divisor
//    let scale = max(1 - scaleFactor, minScale)
//    card.transform = CGAffineTransform(scaleX: scale, y: scale)
  }
  
  private func gestureDidEnd(_ gesture: UIPanGestureRecognizer) {
    guard let card = gesture.view else {
      assertionFailure("Gesture recognizer view should not be nil")
      return
    }
    
    let quarterHeight = card.frame.height / 4
    
    if card.center.y > originalCenter.y + quarterHeight {
      presentingViewController?.dismiss(animated: true, completion: nil)
    }
    else {
      UIView.animate(withDuration: 0.2) { [originalCenter] in
        card.center = originalCenter
        card.transform = .identity
      }
    }
  }
}

extension InfoViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return (gestureRecognizer === dismissSwipeGesture && otherGestureRecognizer === panGestureRecognizer)
        || (gestureRecognizer === panGestureRecognizer && otherGestureRecognizer === dismissSwipeGesture)
  }
}
