//
//  AddressModel.swift
//  project-alpha
//
//  Created by Daniel Seitz on 1/15/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import Contacts

typealias AddressDictionary = [String: String]

protocol AddressModel {
  var street: String { get }
  var city: String { get }
  var state: String { get }
  var zipCode: String { get }
  var countryModel: CountryModel { get }
}

extension AddressModel {
  var addressDictionary: AddressDictionary {
    return [
      CNPostalAddressStreetKey: street,
      CNPostalAddressCityKey: city,
      CNPostalAddressStateKey: state,
      CNPostalAddressPostalCodeKey: zipCode,
      CNPostalAddressCountryKey: countryModel.name,
//      CNPostalAddressISOCountryCodeKey: countryModel.isoCode
    ]
  }
  
  var postalAddress: CNPostalAddress {
    let postalAddress = CNMutablePostalAddress()
    postalAddress.street = street
    postalAddress.city = city
    postalAddress.state = state
    postalAddress.postalCode = zipCode
    postalAddress.country = countryModel.name
    postalAddress.isoCountryCode = countryModel.isoCode ?? ""
    
    return postalAddress.copy() as! CNPostalAddress
  }
}

protocol CountryModel {
  var name: String { get }
  var isoCode: String? { get }
}
