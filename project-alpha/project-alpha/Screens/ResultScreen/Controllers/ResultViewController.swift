//
//  ResultViewController.swift
//  project-alpha
//
//  Created by Cher Moua on 11/16/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import MapKit
import YAPI

struct ResultViewControllerPageModel {
  let delegate: ResultViewControllerDelegate
  let infoViewControllerDelegate: InfoViewControllerDelegate
  let searchParameters: SearchParameters

  /// Minimum number of businesses loaded before preloading another batch of businesses
  let refreshThreshold: UInt
  
  init(delegate: ResultViewControllerDelegate,
       infoViewControllerDelegate: InfoViewControllerDelegate,
       searchParameters: SearchParameters,
       refreshThreshold: UInt = 5) {
    self.delegate = delegate
    self.infoViewControllerDelegate = infoViewControllerDelegate
    self.searchParameters = searchParameters
    self.refreshThreshold = refreshThreshold
  }
}

class ResultViewController: PAViewController {
  lazy private var cardViewModel: ResultCardViewModel = {
    return ResultCardViewModel(updateBlock: { [weak self] businessModel in
      guard let card = self?.card, let delegate = self?.infoViewControllerDelegate else { return }
      
      if let businessModel = businessModel {
        card.tapAction = {
          let pageModel = InfoViewControllerPageModelObject(delegate: delegate, businessModel: businessModel)
          let vc = InfoViewController(pageModel: pageModel)
          let animator = PopAnimator()
          animator.originFrame = card.frame
          vc.transitioningDelegate = animator
          self?.present(vc, animated: true, completion: nil)
        }
      }
      card.display(businessModel: businessModel)
    })
  }()
  
  lazy private var backupCardViewModel: ResultCardViewModel = {
    return ResultCardViewModel(updateBlock: { [weak self] businessModel in
      self?.backupCard.display(businessModel: businessModel)
    })
  }()

  private(set) var businesses: [BusinessModel] = []

  private let card: PAView & ResultDisplayable
  private let backupCard: PAView & ResultDisplayable
  private let delegate: ResultViewControllerDelegate
  private let searchParameters: SearchParameters
  private let refreshThreshold: UInt

  private let infoViewControllerDelegate: InfoViewControllerDelegate
  
  init(pageModel: ResultViewControllerPageModel) {
    self.delegate = pageModel.delegate
    self.infoViewControllerDelegate = pageModel.infoViewControllerDelegate
    self.searchParameters = pageModel.searchParameters
    self.refreshThreshold = pageModel.refreshThreshold
    self.card = ResultCardView()
    self.backupCard = ResultCardView()
    
    super.init()
    
    self.delegate.viewController = self
    
    self.setup(card: backupCard, withGestureRecognizer: false)
    self.setup(card: card, withGestureRecognizer: true)

    delegate.retrieveBusinesses(with: searchParameters) { result in
      guard case .ok(let businesses) = result else {
        log(.error, for: .network, message: "Error retrieving business results: \(result.unwrapErr())")
        return
      }
      
      self.businesses = businesses.shuffled()

      guard let business = self.businesses.popFirst() else {
        log(.error, for: .general, message: "No business found in response")
        return
      }
      let backupBusiness = self.businesses.first
      
      DispatchQueue.main.async {
        self.cardViewModel.businessModel = business
        self.backupCardViewModel.businessModel = backupBusiness
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(card: PAView, withGestureRecognizer: Bool) {
    let width = view.frame.width * 0.75
    let height = view.frame.height * 0.75
    card.frame.size = CGSize(width: width, height: height)
    card.center = view.center
    card.backgroundColor = .red
    view.addSubview(card)
    card.isHidden = true
    
    if withGestureRecognizer {
      let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                        action: #selector(panCard(_:)))
      card.addGestureRecognizer(panGestureRecognizer)
    }
  }
  
  private func resetCard(animated: Bool) {
    let resetBlock = {
      self.card.fadeChoiceImage(to: 0.0)
      self.card.center = self.view.center
      self.card.alpha = 1.0
      self.card.transform = .identity
    }
    
    if animated {
      UIView.animate(withDuration: 0.2, animations: resetBlock)
    }
    else {
      resetBlock()
    }
  }
}

// MARK: View Manipulation
extension ResultViewController {
  @objc private func panCard(_ sender: UIPanGestureRecognizer) {
    guard let card = sender.view as? UIView & ResultDisplayable else {
      assertionFailure("Gesture recognizer view should not be nil")
      return
    }

    let xOffset = card.offsetFrom(view: view).x
    let point = sender.translation(in: view)
    card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
    rotate(card: card)
    
    if card.isRight(of: view) {
      card.startChoosing(direction: .right)
    }
    else {
      card.startChoosing(direction: .left)
    }
    
    card.fadeChoiceImage(to: xOffset / view.center.x)
    
    switch sender.state {
    case .ended:
      gestureDidEnd(sender)
    default:
      break
    }
  }
  
  private func rotate(card: UIView) {
    let maxRotationInRadians: CGFloat = 0.61
    let xOffset: CGFloat
    
    if card.isLeft(of: view) {
      xOffset = -card.offsetFrom(view: view).x
    }
    else {
      xOffset = card.offsetFrom(view: view).x
    }
    
    let divisor = (view.frame.width / 2) / maxRotationInRadians
    
    // Assuming width of 100 points:
    // 100 / 2 = 50 (half width of screen is range we want to rotate over)
    // 50 / maxRotationInRadians = divisor (divisor is some value we can use to
    //                                      backwards compute the desired rotation
    //                                      based on distance from center)
    // finalRotation = xOffset / divisor
    card.transform = CGAffineTransform(rotationAngle: xOffset / divisor)
  }
  
  private func gestureDidEnd(_ sender: UIPanGestureRecognizer) {
    guard let card = sender.view else { return assertionFailure("pan view should not be nil") }
    
    let quarterWidth = view.frame.width / 4
    
    // Center point is within the leftmost quadrant of the screen
    if card.center.x < quarterWidth {
      swipe(.left, animated: true)
    }
    // Center point is within the rightmost quadrant of the screen
    else if card.center.x > (view.frame.width - quarterWidth) {
      swipe(.right, animated: true)
    }
    else {
      resetCard(animated: true)
    }
  }
  
  func swipe(_ direction: SwipeDirection, animated: Bool) {
    let completionBlock: (Bool) -> Void = { success in
      switch direction {
      case .left:
        self.delegate.discardOption(self.cardViewModel.businessModel)
      case .right:
        self.delegate.selectOption(self.cardViewModel.businessModel)
      }
    }
    
    if animated {
      let offset: CGFloat = direction.isLeft ? -200 : 200
      UIView.animate(withDuration: 0.3, animations: {
        self.card.center = CGPoint(x: self.card.center.x + offset, y: self.card.center.y + 75)
        self.card.alpha = 0.0
      }, completion: completionBlock)
    }
    else {
      completionBlock(true)
    }
  }
  
  func showNextOption() {
    let displayOption = { [weak self] in
      self?.cardViewModel.businessModel = self?.businesses.popFirst()
      self?.backupCardViewModel.businessModel = self?.businesses.first
      
      self?.resetCard(animated: false)
    }

    if businesses.count < refreshThreshold {
      // Get the next block of restauraunts
      delegate.retrieveBusinesses(with: searchParameters) { [weak self] result in
        guard case .ok(let businesses) = result else {
          print("Error: \(result.unwrapErr())")
          return
        }
        
        self?.businesses.append(contentsOf: businesses.shuffled())
        
        if self?.cardViewModel.businessModel == nil {
          DispatchQueue.main.async {
            displayOption()
          }
        }
      }
    }
    displayOption()
  }
}
