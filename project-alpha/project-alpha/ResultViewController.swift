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
  lazy var actionHandler: ResultViewControllerOperations = {
    return ResultActionHandler(viewController: self)
  }()
  var card: ResultCardView
  var resetButton: UIButton!
  fileprivate var businesses: [BusinessModel] = []
  fileprivate let networkAdapter: NetworkAdapter
  fileprivate let searchParameters: SearchParameters
  
  init(networkAdapter: NetworkAdapter, searchParameters: SearchParameters) {
    self.networkAdapter = networkAdapter
    self.searchParameters = searchParameters
    self.card = ResultCardView(frame: CGRect())
    
    super.init(nibName: nil, bundle: nil)
    card.frame.size = CGSize(width: view.frame.width - 20, height: view.frame.height - 20)
    card.center = view.center
    card.backgroundColor = .red
    self.view.addSubview(card)
    card.isHidden = true

    
    networkAdapter.makeSearchRequest(with: searchParameters) { result in
      guard case .ok(let businesses) = result else {
        log(.error, for: .network, message: "Error retrieving business results: \(result.unwrapErr())")
        return
      }
      
      self.businesses = businesses.shuffled()
      
      guard let business = self.businesses.first else {
        log(.error, for: .general, message: "No business found in response")
        return
      }
      
      DispatchQueue.main.async {
        self.card.isHidden = false
        self.card.businessModel = business
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.resetButton = UIButton(forAutoLayout: ())
    self.resetButton.autoSetDimensions(to: CGSize(width: 160, height: 80))
    self.resetButton.backgroundColor = .red
    self.view.addSubview(self.resetButton)
    self.resetButton.setTitle("RESET", for: .normal)
    self.resetButton.addTarget(actionHandler,
                               action: #selector(ResultViewControllerOperations.resetButtonPressed(_:)),
                               for: .touchUpInside)
    self.resetButton.autoPinEdge(toSuperviewMargin: .top)
    self.resetButton.autoAlignAxis(toSuperviewAxis: .vertical)
    self.resetButton.tintColor = .black
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: actionHandler,
                                                      action: #selector(ResultViewControllerOperations.panCard(_:)))
    card.addGestureRecognizer(panGestureRecognizer)
  }
}

@objc protocol ResultViewControllerOperations {
  func panCard(_ sender: UIPanGestureRecognizer)
  func resetButtonPressed(_ sender: UIButton)
}

class ResultActionHandler: ResultViewControllerOperations {
  let maxRotationInRadians: CGFloat = 0.61
  let viewController: ResultViewController
  
  var view: UIView {
    return viewController.view
  }
  
  init(viewController: ResultViewController) {
    self.viewController = viewController
  }
  
  @objc func resetButtonPressed(_ sender: UIButton) {
    if !self.viewController.businesses.isEmpty {
      self.viewController.businesses.removeFirst()
      self.viewController.card.businessModel = self.viewController.businesses.first
      
      resetCard()
    }
    // TESTING: Get the next chunk of restauraunts, offset is handled in YelpV3NetworkAdapter as a hardcoded value, we will need to go back and make it more generic for it to work
    else {
      self.viewController.networkAdapter.makeSearchRequest(with: self.viewController.searchParameters) { result in
        guard case .ok(let businesses) = result else {
          print("\(result.unwrapErr())")
          return
        }
        
        self.viewController.businesses = businesses.shuffled()
        
        DispatchQueue.main.async {
          self.viewController.card.businessModel = self.viewController.businesses.first
          
          self.resetCard()
        }
      }
    }

  }
  
  @objc func panCard(_ sender: UIPanGestureRecognizer) {
    guard let card = sender.view as? ResultCardView else { return assertionFailure("pan view should not be nil") }
    
    let xOffset = card.offsetFrom(view: view).x
    let point = sender.translation(in: view)
    card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
    rotate(card: card)
    
    if card.isRight(of: view) {
      card.choiceImageView.image = #imageLiteral(resourceName: "fork-and-plate")
    }
    else {
      card.choiceImageView.image = #imageLiteral(resourceName: "fork-and-knife")
    }
    
    card.choiceImageView.alpha = xOffset / view.center.x
    
    switch sender.state {
    case .ended:
      gestureDidEnd(sender)
    default:
      break
    }
  }
  
  private func rotate(card: UIView) {
    let xOffset = card.isLeft(of: view) ? -card.offsetFrom(view: view).x : card.offsetFrom(view: view).x
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
      UIView.animate(withDuration: 0.3) {
        card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
        card.alpha = 0.0
      }
    }
    // Center point is within the rightmost quadrant of the screen
    else if card.center.x > (view.frame.width - quarterWidth) {
      UIView.animate(withDuration: 0.3) {
        card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
        card.alpha = 0.0
      }
    }
    else {
      resetCard()
    }
  }
  
  private func resetCard() {
    UIView.animate(withDuration: 0.2) {
      self.viewController.card.choiceImageView.alpha = 0.0
      self.viewController.card.center = self.view.center
      self.viewController.card.alpha = 1.0
      self.viewController.card.transform = .identity
    }
  }
}
