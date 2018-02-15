//
//  PhotoViewerViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 2/12/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

protocol PhotoViewerDataSource: UIPageViewControllerDataSource {
  var transitionStyle: UIPageViewControllerTransitionStyle { get }
  var firstViewController: UIViewController? { get }
}

class PhotoViewerDataSourceModel: NSObject, PhotoViewerDataSource {
  // TODO: Only scroll style supported
  var transitionStyle: UIPageViewControllerTransitionStyle
  let viewControllers: [UIViewController]
  var firstViewController: UIViewController? {
    return viewControllers.first
  }
  
  private var currentIndex: Int = 0
  
  init(transitionStyle: UIPageViewControllerTransitionStyle, images: [PAImageViewDisplayModel]) {
    self.transitionStyle = transitionStyle
    self.viewControllers = images.map { PhotoViewController(imageDisplayModel: $0) }
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = viewControllers.index(of: viewController), index > 0 else {
      return nil
    }
    
    currentIndex = viewControllers.index(before: index)
    return viewControllers[currentIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = viewControllers.index(of: viewController), index < viewControllers.count - 1 else {
      return nil
    }
    
    currentIndex = viewControllers.index(after: index)
    return viewControllers[currentIndex]
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return viewControllers.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return currentIndex
  }
}

class PhotoViewerViewController: UIPageViewController {
  private var photoDataSource: PhotoViewerDataSource?
  init(dataSource: PhotoViewerDataSource? = nil) {
    self.photoDataSource = dataSource

    super.init(transitionStyle: dataSource?.transitionStyle ?? .scroll, navigationOrientation: .horizontal)
    self.dataSource = dataSource
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let firstViewController = photoDataSource?.firstViewController {
      setViewControllers([firstViewController],
                         direction: .forward,
                         animated: false,
                         completion: nil)
    }
  }
  
  func set(images: [PAImageViewDisplayModel]) {
    let dataSource = PhotoViewerDataSourceModel(transitionStyle: .scroll, images: images)
    
    self.photoDataSource = dataSource
    self.dataSource = dataSource
    
    if let firstViewController = dataSource.firstViewController {
      setViewControllers([firstViewController],
                         direction: .forward,
                         animated: false,
                         completion: nil)
    }
  }
}
