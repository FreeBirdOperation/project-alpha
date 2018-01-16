//
//  MKMapItem+project-alpha.swift
//  project-alpha
//
//  Created by Daniel Seitz on 1/15/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import MapKit

extension MKMapItem {
  convenience init(businessModel: BusinessModel, placemark: MKPlacemark) {
    self.init(placemark: placemark)
    
    self.name = businessModel.name
    // TODO: Add phone number and url info
//    self.phoneNumber = businessModel.phoneNumber
//    self.url = businessModel.url
  }
}
