//
//  MockBusinessModel.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 12/9/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import YAPI
import CoreLocation
@testable import project_alpha

extension Mock {
  static var businessModel: BusinessModel {
    return BusinessModel(name: "Mock",
                         id: "id",
                         image: #imageLiteral(resourceName: "fork-and-knife"),
                         coordinate: CLLocationCoordinate2D(latitude: 100.0, longitude: 200.0),
                         address: Mock.addressModel)
  }
  
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

    var name: String
    var id: String
    var imageReference: ImageReference?
    var coordinate: CLLocationCoordinate2D
    var address: project_alpha.AddressModel?
    
    init(name: String, id: String, image: UIImage, coordinate: CLLocationCoordinate2D, address: project_alpha.AddressModel?) {
      self.name = name
      self.id = id
      self.imageReference = MockImageReference(image: image)
      self.coordinate = coordinate
      self.address = address
    }
  }
}
