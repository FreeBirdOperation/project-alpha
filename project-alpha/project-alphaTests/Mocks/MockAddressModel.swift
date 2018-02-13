//
//  MockAddressModel.swift
//  project-alphaTests
//
//  Created by Daniel Seitz on 2/13/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
@testable import project_alpha

extension Mock {
  
  static var addressModel: AddressModel {
    return AddressModel(street: "1600 Pennsylvania Ave",
                        city: "Washington",
                        state: "DC",
                        zipCode: "20500",
                        countryModel: Mock.countryModel)
  }
  
  static var countryModel: CountryModel {
    return CountryModel(name: "United States", isoCode: "US")
  }
  
  struct AddressModel: project_alpha.AddressModel {
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var countryModel: project_alpha.CountryModel
  }
  
  struct CountryModel: project_alpha.CountryModel {
    var name: String
    var isoCode: String?
  }
}
