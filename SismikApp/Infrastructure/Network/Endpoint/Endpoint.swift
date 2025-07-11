//
//  Endpoint.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Foundation

enum Endpoint {
  case usgsEarthquakes(query: EarthquakeQuery)
  case emscEarthquakes(query: EarthquakeQuery)

  var baseURL: String {
    switch self {
    case .usgsEarthquakes:
      return "https://earthquake.usgs.gov"
    case .emscEarthquakes:
      return "https://www.seismicportal.eu"
    }
  }

  var path: String {
    switch self {
    case .usgsEarthquakes:
      return "/fdsnws/event/1/query"
    case .emscEarthquakes:
      return "/fdsnws/event/1/query"
    }
  }

  var queryItems: [URLQueryItem] {
    switch self {
    case .usgsEarthquakes(let query):
      return USGSQueryItemBuilder().build(from: query)
    case .emscEarthquakes(let query):
      return EMSCQueryItemBuilder().build(from: query)
    }
  }

  var url: URL? {
    var components = URLComponents(string: baseURL)

    components?.path = path
    components?.queryItems = queryItems

    return components?.url
  }

}

