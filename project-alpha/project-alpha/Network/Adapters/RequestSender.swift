//
//  RequestSender.swift
//  project-alpha
//
//  Created by Daniel Seitz on 4/21/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import YAPI

class RequestSender {
  private var observerList: ObserverList<NetworkObserver> = ObserverList()

  func addObserver(_ observer: NetworkObserver) {
    observerList.addObserver(observer)
  }
  
  func removeObserver(_ observer: NetworkObserver) {
    observerList.removeObserver(observer)
  }
  
 func sendRequest<RequestType: Request>(_ request: RequestType,
                                                 completionHandler: @escaping (Result<RequestType.ResponseType, APIError>) -> Void) {
    observerList.notifyObservers { observer in
      observer.loadBegan()
    }
    request.send { [weak self] result in
      self?.observerList.notifyObservers { observer in
        observer.loadEnded()
      }
      completionHandler(result)
    }
  }
}
