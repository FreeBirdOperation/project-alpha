//
//  MockBusinessModel.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/9/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI
@testable import project_alpha

extension Mock {
  static var businessModel: BusinessModel { return BusinessModel(name: "Mock", id: "id", image: #imageLiteral(resourceName: "fork-and-knife")) }
  
  struct BusinessModel: project_alpha.BusinessModel {
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
    let id: String
    let imageReference: ImageReference?
    
    init(name: String, id: String, image: UIImage) {
      self.name = name
      self.id = id
      self.imageReference = MockImageReference(image: image)
    }
  }
}
