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

protocol RatingModel {
  var value: Double { get }
}

protocol PriceModel {
  var value: Double { get }
}

protocol CategoryModel {
  var name: String { get }
  var displayName: String { get }
}

protocol BusinessModel {
  var id: String { get }
  var name: String { get }
  var imageReferences: [ImageReference] { get }
  var coordinate: CLLocationCoordinate2D { get }
  var address: AddressModel? { get }
  var businessCategories: [CategoryModel] { get }
  var reviews: [ReviewModel] { get }
  var url: URL? { get }
  var businessRating: RatingModel { get }
  var businessPrice: PriceModel? { get }
}

struct MutableBusinessModel: BusinessModel {
  var id: String
  var name: String
  var imageReferences: [ImageReference]
  var coordinate: CLLocationCoordinate2D
  var address: AddressModel?
  var businessCategories: [CategoryModel]
  var reviews: [ReviewModel]
  var url: URL?
  var businessRating: RatingModel
  var businessPrice: PriceModel?
  
  init(businessModel: BusinessModel) {
    self.id = businessModel.id
    self.name = businessModel.name
    self.imageReferences = businessModel.imageReferences
    self.coordinate = businessModel.coordinate
    self.address = businessModel.address
    self.businessCategories = businessModel.businessCategories
    self.reviews = businessModel.reviews
    self.url = businessModel.url
    self.businessRating = businessModel.businessRating
    self.businessPrice = businessModel.businessPrice
  }
}
