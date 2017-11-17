//
//  ViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 11/12/17.
//  Copyright © 2017 freebird. All rights reserved.
//

import UIKit
import YAPI

class ViewController: UIViewController {
  
  private func getKeys() -> [String: String] {
    guard
      let path = Bundle.main.path(forResource: "secrets", ofType: "plist"),
      let keys = NSDictionary(contentsOfFile: path) as? [String: String]
      else {
        assertionFailure("Unable to load secrets property list, contact dnseitz@gmail.com if you need the file")
        return [:]
    }
    return keys
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let keys = getKeys()
    guard
      let appId = keys["APP_ID"],
      let clientSecret = keys["CLIENT_SECRET"],
      let googleKey = keys["GOOGLE_APP_ID"]
      else {
        assertionFailure("Unable to retrieve appId or clientSecret from file")
        return
    }
    let authToken = YelpV3AuthenticationToken(appId: appId, clientSecret: clientSecret)
    
    YelpV3Authenticator.authenticate(with: authToken) { result in
      guard case .ok(let networkAdapter) = result else {
        print("Error authenticating: \(result.unwrapErr())")
        return
      }
      
      let params = SearchParameters(distance: 1000)
      networkAdapter.makeSearchRequest(with: params) { result in
        guard case .ok(let businesses) = result else {
          print("Error in response: \(result.unwrapErr())")
          return
        }
        
        for business in businesses {
          print(business.name)
        }
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

