//
//  GooglePlaceSearchResponse.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/15/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

public final class GooglePlaceSearchResponse: Response {
  
  private enum Params {
    static let status = "status"
    static let results = "results"
    static let html_attributions = "html_attributions"
    static let next_page_token = "next_page_token"
    static let error_message = "error_message"
  }

  public let error: APIError?
  public let results: [GoogleEstablishment]
  public let nextPageToken: String?

  public init(withJSON data: [String : AnyObject]) throws {
    let decoder = JSONDecoder()
    self.error = try GooglePlaceSearchResponse.parseError(from: data)
    
    do {
      self.results = try decoder.decode(Array<GoogleEstablishment>.self,
                                        from: JSONSerialization.data(withJSONObject: data[Params.results] as Any))
      self.nextPageToken = try? data.parseParam(key: Params.next_page_token)
    }
    catch {
      throw ParseError.decoderFailed(cause: error)
    }
  }
}

extension GooglePlaceSearchResponse {
  static func parseError(from data: [String: AnyObject]) throws -> GoogleResponseError? {
    let status: String = try data.parseParam(key: Params.status)
    let message: String? = try? data.parseParam(key: Params.error_message)
    
    switch status {
    case "ZERO_RESULTS":
      fallthrough
    case "OK":
      return nil
    case "OVER_QUERY_LIMIT":
      return .overQueryLimit(message: message)
    case "REQUEST_DENIED":
      return .requestDenied(message: message)
    case "INVALID_REQUEST":
      return .invalidRequest(message: message)
    default:
      throw ParseError.invalid(field: Params.status, value: status)
    }
  }
}
