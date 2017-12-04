//
//  BusinessModel.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/22/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI

protocol BusinessModel {
  var id: String { get }
  var name: String { get }
  var imageReference: ImageReference? { get }
}

struct MockBusiness: BusinessModel {
  private final class MockImageReference: ImageReference {
    let _image: UIImage
    
    override var cachedImage: UIImage? {
      return _image
    }
    
    init(image: UIImage) {
      self._image = image
      super.init(from: URL(string: "https://google.com")!)
    }
  }
  
  let name: String
  let imageReference: ImageReference?
  let id: String = "id"
  
  init(name: String, image: UIImage) {
    self.name = name
    self.imageReference = MockImageReference(image: image)
  }
}
