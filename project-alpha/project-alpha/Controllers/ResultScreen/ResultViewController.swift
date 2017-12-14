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

class ResultViewController: UIViewController {
  lazy private var actionHandler: ResultViewControllerOperations = {
    return ResultActionHandler(viewController: self, networkAdapter: self.networkAdapter)
  }()

  lazy private var cardViewModel: ResultCardViewModel = {
    return ResultCardViewModel(updateBlock: { [weak self] businessModel in
      self?.card.display(businessModel: businessModel)
    })
  }()
  
  lazy private var backupCardViewModel: ResultCardViewModel = {
    return ResultCardViewModel(updateBlock: { [weak self] businessModel in
      self?.backupCard.display(businessModel: businessModel)
    })
  }()

  private var card: UIView & ResultDisplayable
  private var backupCard: UIView & ResultDisplayable
  private var businesses: [BusinessModel] = []
  private let networkAdapter: NetworkAdapter
  private let searchParameters: SearchParameters
  
  init(networkAdapter: NetworkAdapter, searchParameters: SearchParameters) {
    self.networkAdapter = networkAdapter
    self.searchParameters = searchParameters
    self.card = ResultCardView()
    self.backupCard = ResultCardView()
    
    super.init(nibName: nil, bundle: nil)
    
    self.setup(card: backupCard, withGestureRecognizer: false)
    self.setup(card: card, withGestureRecognizer: true)

    actionHandler.retrieveBusinesses(with: searchParameters) { result in
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black
  }
  
  private func setup(card: UIView, withGestureRecognizer: Bool) {
    card.frame.size = CGSize(width: view.frame.width - 20, height: view.frame.height - 20)
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
      UIView.animate(withDuration: 0.3, animations: {
        card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
        card.alpha = 0.0
      }, completion: { (success) in
        self.showNextOption()
        self.actionHandler.discardOption()
      })
    }
      // Center point is within the rightmost quadrant of the screen
    else if card.center.x > (view.frame.width - quarterWidth) {
      UIView.animate(withDuration: 0.3, animations: {
        card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
        card.alpha = 0.0
      }, completion: { (success) in
        self.showNextOption()
        self.actionHandler.selectOption()
      })
    }
    else {
      resetCard(animated: true)
    }
  }
  
  private func showNextOption() {
    if businesses.count > 1 {
      cardViewModel.businessModel = businesses.popFirst()
      backupCardViewModel.businessModel = businesses.first
      
      resetCard(animated: false)
    }
      // TESTING: Get the next chunk of restauraunts, offset is handled in YelpV3NetworkAdapter as a hardcoded value, we will need to go back and make it more generic for it to work
    else {
      actionHandler.retrieveBusinesses(with: searchParameters) { [weak self] result in
        
        guard case .ok(let businesses) = result else {
          print("Error: \(result.unwrapErr())")
          return
        }
        
        self?.businesses.append(contentsOf: businesses)
        
        DispatchQueue.main.async {
          self?.cardViewModel.businessModel = self?.businesses.popFirst()
          self?.backupCardViewModel.businessModel = self?.businesses.first
          self?.resetCard(animated: false)
        }
      }
    }
  }
}
