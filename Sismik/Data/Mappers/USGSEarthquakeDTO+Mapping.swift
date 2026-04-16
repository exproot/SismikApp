//
//  USGSEarthquakeDTO+Mapping.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Foundation

extension USGSEarthquakeDTO: EarthquakeDTOConvertible {
  func toDomainModel() -> Earthquake {
    let longitude = geometry.coordinates[0]
    let latitude = geometry.coordinates[1]
    let depth = geometry.coordinates[2]
    let time = DateParsers.fromUnixMilliseconds(properties.time)

    return Earthquake(
      id: id,
      title: properties.title,
      magnitude: properties.mag ?? 0.0,
      place: properties.place,
      time: time,
      latitude: latitude,
      longitude: longitude,
      depth: depth
    )
  }
}


