//
//  CarouselView.swift
//  project-alpha
//
//  Created by Daniel Seitz on 6/9/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

private let CarouselCellIdentifier = "CarouselCell"

class CarouselViewModel: NSObject, UICollectionViewDataSource {
  var carouselViews: [PAView] = []
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return carouselViews.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCellIdentifier, for: indexPath)
    
    let contentView = carouselViews[indexPath.row]
    if contentView.superview != nil {
      contentView.removeFromSuperview()
    }
    cell.contentView.addSubview(contentView)
    contentView.autoPinEdgesToSuperviewEdges()
    
    return cell
  }
}

class CarouselView: PAView, UICollectionViewDelegate {
  private let internalCollectionView: UICollectionView
  public var displayModel: CarouselViewModel? {
    didSet {
      internalCollectionView.dataSource = displayModel
    }
  }
  
  override init() {
    internalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    super.init()
    
    addSubview(internalCollectionView)
    internalCollectionView.autoPinEdgesToSuperviewEdges()
    
    internalCollectionView.delegate = self
    internalCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CarouselCellIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let layout = PACollectionViewCarouselLayout()
    
    let itemWidth = frame.size.width * 2 / 3
    let itemHeight = frame.size.height
    let itemSize = CGSize(width: itemWidth, height: itemHeight)
    layout.itemSize = itemSize
    layout.scrollDirection = .horizontal
    
    internalCollectionView.collectionViewLayout = layout
  }
}

private class PACollectionViewCarouselLayout: UICollectionViewFlowLayout {
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    let itemWidth = itemSize.width + minimumLineSpacing
    let halfItemWidth = itemWidth / 2
    
    let pages = ((proposedContentOffset.x + halfItemWidth) / itemWidth).rounded(.down)
    
    return CGPoint(x: itemWidth * pages, y: proposedContentOffset.y)
  }
  
  override var collectionViewContentSize: CGSize {
    guard let collectionView = collectionView else {
        return super.collectionViewContentSize
    }
        
    let numItems = CGFloat(collectionView.numberOfItems(inSection: 0))
    let itemWidth = itemSize.width + minimumLineSpacing
    let paddingNeeded = collectionView.frame.width - itemWidth
    let contentSize = itemWidth * numItems + paddingNeeded
    return CGSize(width: contentSize, height: collectionView.frame.height)
  }
}
