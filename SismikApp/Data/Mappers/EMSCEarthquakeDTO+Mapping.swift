//
//  EMSCEarthquakeDTO+Mapping.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 15.06.2025.
//

import Foundation

extension EMSCEarthquakeDTO: EarthquakeDTOConvertible {
  func toDomainModel() -> Earthquake {
    let longitude = geometry.coordinates[0]
    let latitude = geometry.coordinates[1]
    let depth = geometry.coordinates[2]
    let date = DateParsers.emsc.date(from: properties.time) ?? Date()

    return Earthquake(
      id: id,
      title: "\(properties.mag) - \(properties.flynn_region)",
      magnitude: properties.mag,
      place: properties.flynn_region,
      time: date,
      latitude: latitude,
      longitude: longitude,
      depth: depth
    )
  }
}
