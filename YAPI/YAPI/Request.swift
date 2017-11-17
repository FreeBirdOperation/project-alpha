//
//  YelpInterfaceModel.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/22/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation
import OAuthSwift


// Cached oauth clients for sending requests
private var OAuth1Client: OAuthSwiftClient? = nil
private var OAuth2Client: OAuthSwiftClient? = nil
// FIXME: Create simple Network Client for API's not requiring OAuth (Google)
private var SwiftClient: OAuthSwiftClient = OAuthSwiftClient(consumerKey: "", consumerSecret: "")
private func oAuthClient(for version: OAuthSwiftCredential.Version?) -> OAuthSwiftClient? {
  guard let version = version else {
    return SwiftClient
  }
  switch version {
  case .oauth1:
    if let client = OAuth1Client {
      return client
    }
    else {
      guard
        let consumerKey = AuthKeys.consumerKey,
        let consumerSecret = AuthKeys.consumerSecret,
        let token = AuthKeys.token,
        let tokenSecret = AuthKeys.tokenSecret
        else {
          assert(false, "The request requires a consumerKey, consumerSecret, token, and tokenSecret in order to access the Yelp API, set these through the YelpAPIFactory")
          return nil
      }
      let client = OAuthSwiftClient(consumerKey: consumerKey, consumerSecret: consumerSecret, oauthToken: token, oauthTokenSecret: tokenSecret, version: .oauth1)
      OAuth1Client = client
      return client
    }
  case .oauth2:
    if let client = OAuth2Client {
      if let token = AuthKeys.token {
        client.credential.oauthToken = token
      }
      return client
    }
    else {
      guard
        let consumerKey = AuthKeys.consumerKey,
        let consumerSecret = AuthKeys.consumerSecret
        else {
          assert(false, "The request requires a consumerKey and consumerSecret in order to access the Yelp API, set these through the YelpAPIFactory")
          return nil
      }
      let credential = OAuthSwiftCredential(consumerKey: consumerKey, consumerSecret: consumerSecret)
      credential.version = .oauth2
      let client = OAuthSwiftClient(credential: credential)
      OAuth2Client = client
      return client
    }
  }
}

/**
    Any request that can be sent to the Yelp API conforms to this protocol. This could include requests to 
    the search API, business API, etc. The sendRequest function will query the Yelp API and return either a 
    response or an error.
 
    - Usage:
    ```
      // Given some Request
 
      // Send the request and handle the response
      yelpRequest.send() { (response, error) in
        // Handle response or error
      }
    ```
 */
public protocol Request {
  associatedtype ResponseType: Response
  
  /// The version of OAuth to use
  var oauthVersion: OAuthSwiftCredential.Version? { get }
  
  /// The hostname of the endpoint
  var host: String { get }
  
  /// The path to the api resource
  var path: String { get }
  
  /// Query parameters to include in the request
  var parameters: [String: String] { get }
  
  /// The HTTP Method used for this request
  var requestMethod: OAuthSwiftHTTPRequest.Method { get }
  
  /// The http session used to send this request
  var session: HTTPClient { get }
  
  /**
   Sends the request, calling the given handler with either the yelp response or an error. This can be
   called multiple times to retry sending the request
   
   - Parameter completionHandler: The block to call when the response returns, takes a Response? and
   a YelpError? as arguments, the error can be of YelpResponseError type or YelpRequestError type
   */
  func send(completionHandler handler: @escaping (_ result: Result<Self.ResponseType, APIError>) -> Void)
}

public extension Request {
  public func send(completionHandler handler: @escaping (_ result: Result<Self.ResponseType, APIError>) -> Void) {
    self.internalSend(completionHandler: handler)
  }
}

internal extension Request {
  func internalSend(completionHandler handler: @escaping (_ result: Result<Self.ResponseType, APIError>) -> Void) {
    guard let urlRequest = self.generateURLRequest() else {
      handler(.err(RequestError.failedToGenerateRequest))
      return
    }
    
    self.session.send(urlRequest) {(data, response, error) in
      var result: Result<Self.ResponseType, APIError>
      defer {
        handler(result)
      }
      
      if let err = error {
        result = .err(RequestError.failedToSendRequest(err as NSError))
        return
      }
      
      guard let jsonData = data else {
        result = .err(YelpResponseError.noDataRecieved)
        return
      }
      
      result = APIFactory.makeResponse(with: jsonData, from: self)
    }
  }
}

fileprivate extension Request {
  func generateURLRequest() -> URLRequest? {
    guard
      let client = oAuthClient(for: oauthVersion),
      let request = client.makeRequest("https://\(self.host)\(self.path)",
                                        method: self.requestMethod,
                                        parameters: self.parameters,
                                        headers: nil,
                                        body: nil) else {
      return nil
    }
    
    return try? request.makeRequest()
  }
}
