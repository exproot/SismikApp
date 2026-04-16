//
//  EMSCQueryItemBuilder.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 15.06.2025.
//

import Foundation

struct EMSCQueryItemBuilder: QueryItemBuilder {
  func build(from query: EarthquakeQuery) -> [URLQueryItem] {
    var items = [
      URLQueryItem(name: "format", value: "json"),
      URLQueryItem(name: "orderby", value: query.orderBy),
      URLQueryItem(name: "limit", value: "\(query.limit)"),
    ]

    if let latitude = query.latitude {
      items.append(.init(name: "latitude", value: "\(latitude)"))
    }

    if let longitude = query.longitude {
      items.append(.init(name: "longitude", value: "\(longitude)"))
    }

    if let radiusInKm = query.radiusKm {
      items.append(.init(name: "maxradius", value: "\(radiusInKm.toDegreesApprox())"))
    }

    if let minMagnitude = query.minMagnitude {
      items.append(.init(name: "minmag", value: "\(minMagnitude)"))
    }

    if let maxMagnitude = query.maxMagnitude {
      items.append(.init(name: "maxmag", value: "\(maxMagnitude)"))
    }

    if let startTime = query.startTime {
      let formatted = DateFormatter.earthquakeAPIFormatter.string(from: startTime)
      items.append(.init(name: "starttime", value: formatted))
    }

    if let endTime = query.endTime {
      let formatted = DateFormatter.earthquakeAPIFormatter.string(from: endTime)
      items.append(.init(name: "endtime", value: formatted))
    }

    return items
  }
}
