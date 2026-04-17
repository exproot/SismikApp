//
//  USGSQueryItemBuilder.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public struct USGSQueryItemBuilder: QueryItemBuilding {

  public init() {}
  
  public func build(from request: EarthquakeRequest) -> [URLQueryItem] {
    var items: [URLQueryItem] = [
      URLQueryItem(name: "format", value: "geojson"),
      URLQueryItem(name: "orderby", value: request.orderBy),
      URLQueryItem(name: "limit", value: "\(request.limit)"),
    ]
    
    if let latitude = request.latitude {
      items.append(URLQueryItem(name: "latitude", value: "\(latitude)"))
    }
    
    if let longitude = request.longitude {
      items.append(URLQueryItem(name: "longitude", value: "\(longitude)"))
    }
    
    if let radiusKm = request.radiusKm {
      items.append(.init(name: "maxradiuskm", value: "\(radiusKm)"))
    }

    if let minMagnitude = request.minMagnitude {
      items.append(.init(name: "minmagnitude", value: "\(minMagnitude)"))
    }

    if let maxMagnitude = request.maxMagnitude {
      items.append(.init(name: "maxmagnitude", value: "\(maxMagnitude)"))
    }

    if let startTime = request.startTime {
      items.append(.init(name: "starttime", value: Self.apiDateFormatter.string(from: startTime)))
    }

    if let endTime = request.endTime {
      items.append(.init(name: "endtime", value: Self.apiDateFormatter.string(from: endTime)))
    }

    if let eventType = request.eventType {
      items.append(.init(name: "eventtype", value: eventType))
    }
    
    return items
  }
  
  nonisolated(unsafe) private static let apiDateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()
  
}
