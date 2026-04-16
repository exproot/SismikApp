//
//  USGSEarthquakeMapper.swift
//  Sismik
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import EarthquakeRemote
import Foundation

enum USGSEarthquakeMapper {
  static func map(_ dto: USGSEarthquakeDTO) -> Earthquake {
    let longitude = dto.geometry.coordinates[safe: 0] ?? 0
    let latitude = dto.geometry.coordinates[safe: 1] ?? 0
    let depth = dto.geometry.coordinates[safe: 2] ?? 0
    let time = DateParsers.fromUnixMilliseconds(dto.properties.time)
    
    return Earthquake(
      id: dto.id,
      title: dto.properties.title,
      magnitude: dto.properties.mag ?? 0,
      place: dto.properties.place,
      time: time,
      latitude: latitude,
      longitude: longitude,
      depth: depth
    )
  }
}

extension Array {
  subscript(safe index: Int) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
