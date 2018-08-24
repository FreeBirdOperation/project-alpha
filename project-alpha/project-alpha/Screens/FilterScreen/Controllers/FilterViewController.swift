//
//  FilterViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 8/23/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation

class FilterViewController: PAViewController {
  // Allow user to choose:
  //  - categories: Bars, Dessert, etc.
  //  - sorting: distance, rating
  //  - price: $, $$, $$$, $$$$
  //  - open at: now, 10:30 am, 5:30 pm, etc
  let collectionView: PACollectionView
  
  override init() {
    collectionView = PACollectionView()
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
