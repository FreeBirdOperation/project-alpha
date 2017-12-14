//
//  MGLMapView+project-alpha.swift
//  project-alpha
//
//  Created by Daniel Seitz on 12/11/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import Foundation
import Mapbox

enum MGLMapViewStyle {
  case streets
  case dark
  case light
  case outdoors
  case satalliteStreets
  case satallite
}

fileprivate extension MGLMapViewStyle {
  var styleURL: URL? {
    switch self {
    case .streets: return URL(string: "mapbox://styles/mapbox/streets-v10")
    case .dark: return URL(string: "mapbox://styles/mapbox/dark-v9")
    case .light: return URL(string: "mapbox://styles/mapbox/light-v9")
    case .outdoors: return URL(string: "mapbox://styles/mapbox/outdoors-v10")
    case .satalliteStreets: return URL(string: "mapbox://styles/mapbox/satellite-streets-v10")
    case .satallite: return URL(string: "mapbox://styles/mapbox/satellite-v9")
    }
  }
}

extension MGLMapView {
  convenience init(style: MGLMapViewStyle) {
    self.init(frame: CGRect.zero, styleURL: style.styleURL)
  }
}
