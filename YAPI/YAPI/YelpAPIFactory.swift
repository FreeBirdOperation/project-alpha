//
//  YelpAPIFactory.swift
//  Chowroulette
//
//  Created by Daniel Seitz on 7/25/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation
import CoreLocation

/**
    Factory class that generates Yelp requests and responses for use.
 */
public enum YelpAPIFactory {
  /// The parameters to use when determining localization
  public static var localeParameters: YelpLocaleParameters?
  
  /// The parameters to use to determine whether to show action links
  public static var actionlinkParameters: YelpActionlinkParameters?
  
  /**
      Set the authentication keys that will be used to generate requests. These keys are needed in order 
      for the Yelp API to successfully authenticate your requests, if you generate a request without these 
      set the request will fail to send
   
      - Parameters:
        - consumerKey: The OAuth consumer key
        - consumerSecret: The OAuth consumer secret
        - token: The OAuth token
        - tokenSecret: The OAuth token secret
   */
  public static func setAuthenticationKeys(consumerKey: String,
                                        consumerSecret: String,
                                                 token: String,
                                           tokenSecret: String) {
    AuthKeys.consumerKey = consumerKey
    AuthKeys.consumerSecret = consumerSecret
    AuthKeys.token = token
    AuthKeys.tokenSecret = tokenSecret
  }
  
  /**
      Build a request with the specified request parameters
   
      - Parameter params: A struct containing information with which to create a request
   
      - Returns: A fully formed request that can be sent immediately
   */
  public static func makeSearchRequest(with parameters: YelpSearchParameters) -> YelpSearchRequest {
    
    return YelpSearchRequest(search: parameters, locale: self.localeParameters, actionlink: self.actionlinkParameters)
  }
  
  /**
      Build a response from the JSON body recieved from making a request.
   
      - Parameter json: A dictionary containing the JSON body recieved in the Yelp response
      - Parameter request: The request that was sent in order to recieve this response
   
      - Returns: A valid response object, populated with businesses or an error
   */
  static func makeResponse(withJSON json: [String: AnyObject], from request: YelpRequest) -> YelpResponse {
    return YelpResponse(withJSON: json, from: request)
  }
  
  /**
      Build a response from the still encoded body recieved from making a request.
   
      - Parameter data: An NSData object of the data recieved from a Yelp response
      - Parameter request: The request that was sent in order to recieve this response
   
      - Returns: A valid response object, or nil if the data cannot be parsed
   */
  static func makeResponse(with data: NSData, from request: YelpRequest) -> YelpResponse? {
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
      return YelpResponse(withJSON: json as! [String: AnyObject], from: request)
    }
    catch {
      return nil
    }
  }
  
}