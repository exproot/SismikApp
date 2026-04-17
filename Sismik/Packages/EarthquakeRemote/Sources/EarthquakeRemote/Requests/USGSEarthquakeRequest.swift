//
//  USGSEarthquakeRequest.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import CoreNetworking
import Foundation

public struct USGSEarthquakeRequest: Requestable {

  public let queryItems: [URLQueryItem]
  
  public init(queryItems: [URLQueryItem]) {
    self.queryItems = queryItems
  }
  
  public var baseURL: String {
    "https://earthquake.usgs.gov"
  }
  
  public var path: String {
    "/fdsnws/event/1/query"
  }
  
  public var method: HTTPMethod {
    .get
  }
  
  public var headers: [String : String] {
    [:]
  }
  
}
