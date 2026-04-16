//
//  EMSCEarthquakeMapper.swift
//  Sismik
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import EarthquakeRemote
import Foundation

enum EMSCEarthquakeMapper {
  static func map(_ dto: EMSCEarthquakeDTO) -> Earthquake {
    let longitude = dto.geometry.coordinates[safe: 0] ?? dto.properties.lon
    let latitude = dto.geometry.coordinates[safe: 1] ?? dto.properties.lat
    let depth = dto.geometry.coordinates[safe: 2] ?? dto.properties.depth
    let date = DateParsers.emsc.date(from: dto.properties.time) ?? Date()
    
    return Earthquake(
      id: dto.id,
      title: "\(dto.properties.mag) - \(dto.properties.flynn_region)",
      magnitude: dto.properties.mag,
      place: dto.properties.flynn_region,
      time: date,
      latitude: latitude,
      longitude: longitude,
      depth: depth
    )
  }
}
