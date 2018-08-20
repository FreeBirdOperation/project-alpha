//
//  ReviewModel.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/26/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

protocol ReviewModel {
  var userImage: ImageReference? { get }
  var userName: String { get }
  var rating: Int { get }
  var text: String { get }
}
