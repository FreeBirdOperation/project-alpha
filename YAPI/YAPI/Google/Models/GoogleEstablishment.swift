//
//  GoogleEstablishment.swift
//  YAPI
//
//  Created by Daniel Seitz on 11/16/17.
//  Copyright © 2017 Daniel Seitz. All rights reserved.
//

import Foundation

public struct GoogleEstablishment: Decodable {
  
  public struct Geometry: Codable {
    public struct Location: Codable {
      public let lat: Double
      public let lng: Double
    }
    public let location: Location
  }
  
  public struct OpeningHours: Codable {
    public let open_now: Bool
  }
  
  public struct Photo: Decodable {
    public final class PhotoReference: ImageReference {
      private enum Params {
        static let key = "key"
        static let photoreference = "photoreference"
        static let maxheight = "maxheight"
        static let photo_reference = "photo_reference"
      }
      
      static func buildURL(fromReference reference: String) throws -> URL {
        guard let apiKey = GoogleAuth.token else {
          assertionFailure("Google api key should be set already")
          throw GoogleResponseError.requestDenied(message: "Google Auth Key should be set")
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = APIEndpoints.Google.host
        components.path = APIEndpoints.Google.photo
        let keyQuery = URLQueryItem(name: Params.key, value: apiKey.token)
        let refQuery = URLQueryItem(name: Params.photoreference, value: reference)
        // Max queryable height to get highest resolution photo
        let heightQuery = URLQueryItem(name: Params.maxheight, value: "1600")
        components.queryItems = [keyQuery, refQuery, heightQuery]
        guard let url = components.url else {
          throw ParseError.invalid(field: Params.photo_reference, value: reference)
        }
        return url
      }
      
      public required convenience init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        let reference = try value.decode(String.self)
        
        let url = try PhotoReference.buildURL(fromReference: reference)
        
        self.init(from: url)
      }
    }

    public let photo_reference: PhotoReference
    public let height: Int
    public let width: Int
    public let html_attributations: [String]?
  }
  
  public enum Scope: String, Codable {
    case app = "APP"
    case google = "GOOGLE"
  }
  
  public struct AltId: Codable {
    public let place_id: String
    public let scope: Scope
  }
  
  public enum PriceLevel: Int, Codable {
    case zero
    case one
    case two
    case three
    case four
  }
  
  public let icon: ImageReference
  public let geometry: Geometry
  public let name: String
  public let opening_hours: OpeningHours?
  public let photos: [Photo]?
  public let place_id: String
  public let scope: Scope?
  public let alt_ids: [AltId]?
  public let price_level: PriceLevel?
  public let rating: Double?
  // public let types: [Type]
  public let vicinity: String?
  public let formatted_address: String?
  public let permanently_closed: Bool?
  
}
