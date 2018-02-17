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
//  var imageReference: ImageReference? { get }
  var coordinate: CLLocationCoordinate2D { get }
  var address: AddressModel? { get }
}
