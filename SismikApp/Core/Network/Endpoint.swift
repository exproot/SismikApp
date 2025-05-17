//
//  Endpoint.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Foundation

enum Endpoint {
  case earthquakes(query: EarthquakeQuery)

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
    case .earthquakes(let query):
      var items = [
        URLQueryItem(name: "format", value: "geojson"),
        URLQueryItem(name: "orderby", value: query.orderBy),
        URLQueryItem(name: "limit", value: "\(query.limit)"),
      ]

      if let minLatitude = query.minLatitude {
        items.append(.init(name: "minlatitude", value: "\(minLatitude)"))
      }

      if let maxLatitude = query.maxLatitude {
        items.append(.init(name: "maxlatitude", value: "\(maxLatitude)"))
      }

      if let minLongitude = query.minLongitude {
        items.append(.init(name: "minlongitude", value: "\(minLongitude)"))
      }

      if let maxLongitude = query.maxLongitude {
        items.append(.init(name: "maxlongitude", value: "\(maxLongitude)"))
      }

      if let minMagnitude = query.minMagnitude {
        items.append(.init(name: "minmagnitude", value: "\(minMagnitude)"))
      }

      if let maxMagnitude = query.maxMagnitude {
        items.append(.init(name: "maxmagnitude", value: "\(maxMagnitude)"))
      }

      if let startTime = query.startTime {
        let formatted = Self.dateFormatter.string(from: startTime)
        items.append(.init(name: "starttime", value: formatted))
      }

      if let endTime = query.endTime {
        let formatted = Self.dateFormatter.string(from: endTime)
        items.append(.init(name: "endtime", value: formatted))
      }

      if let eventType = query.eventType {
        items.append(.init(name: "eventtype", value: eventType))
      }

      return items
    }
  }

  static let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    return df
  }()

  var url: URL? {
    var components = URLComponents(string: baseURL)

    components?.path = path
    components?.queryItems = queryItems

    return components?.url
  }

}
