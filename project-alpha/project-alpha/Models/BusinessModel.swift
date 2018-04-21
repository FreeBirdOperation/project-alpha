//
//  BusinessModel.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/22/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import CoreLocation
import YAPI

protocol BusinessModel {
  var id: String { get }
  var name: String { get }
  var imageReferences: [ImageReference] { get }
  var coordinate: CLLocationCoordinate2D { get }
  var address: AddressModel? { get }
}

struct MutableBusinessModel: BusinessModel {
  var id: String
  var name: String
  var imageReferences: [ImageReference]
  var coordinate: CLLocationCoordinate2D
  var address: AddressModel?
  
  init(businessModel: BusinessModel) {
    self.id = businessModel.id
    self.name = businessModel.name
    self.imageReferences = businessModel.imageReferences
    self.coordinate = businessModel.coordinate
    self.address = businessModel.address
  }
}
