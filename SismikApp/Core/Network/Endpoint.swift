//
//  Endpoint.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Foundation

enum Endpoint {
  case earthquakes(minLatitude: Double?, maxLatitude: Double?, minLongitude: Double?, maxLongitude: Double?)

  var baseURL: String {
    "https://earthquake.usgs.gov"
  }

  var path: String {
    switch self {
    case .earthquakes:
      return "/fdsnws/event/1/query"
    }
  }

  var queryItems: [URLQueryItem] {
    switch self {
    case .earthquakes(let minLat, let maxLat, let minLon, let maxLon):
      var items = [
        URLQueryItem(name: "format", value: "geojson"),
        URLQueryItem(name: "orderby", value: "time"),
        URLQueryItem(name: "limit", value: "50"),
      ]

      if let minLat, let maxLat, let minLon, let maxLon {
        items.append(contentsOf: [
          URLQueryItem(name: "minlatitude", value: "\(minLat)"),
          URLQueryItem(name: "maxlatitude", value: "\(maxLat)"),
          URLQueryItem(name: "minlongitude", value: "\(minLon)"),
          URLQueryItem(name: "maxlongitude", value: "\(maxLon)")
        ])
      }

      return items
    }
  }

  var url: URL? {
    var components = URLComponents(string: baseURL)

    components?.path = path
    components?.queryItems = queryItems

    return components?.url
  }
}
