//
//  EMSCQueryItemBuilder.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public struct EMSCQueryItemBuilder: QueryItemBuilding {
  
  public init() {}
  
  public func build(from request: EarthquakeRequest) -> [URLQueryItem] {
    var items = [
      URLQueryItem(name: "format", value: "json"),
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
      items.append(URLQueryItem(name: "maxradius", value: "\(kilometersToApproxDegrees(radiusKm))"))
    }

    if let minMagnitude = request.minMagnitude {
      items.append(URLQueryItem(name: "minmag", value: "\(minMagnitude)"))
    }

    if let maxMagnitude = request.maxMagnitude {
      items.append(URLQueryItem(name: "maxmag", value: "\(maxMagnitude)"))
    }

    if let startTime = request.startTime {
      items.append(URLQueryItem(name: "starttime", value: Self.apiDateFormatter.string(from: startTime)))
    }

    if let endTime = request.endTime {
      items.append(URLQueryItem(name: "endtime", value: Self.apiDateFormatter.string(from: endTime)))
    }

    return items
  }
  
  private func kilometersToApproxDegrees(_ kilometers: Double) -> Double {
    kilometers / 111.0
  }
  
  nonisolated(unsafe) private static let apiDateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()
  
}
