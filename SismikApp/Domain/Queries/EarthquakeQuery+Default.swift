//
//  EarthquakeQuery+Default.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//


import CoreLocation
import Foundation

extension EarthquakeQuery {

  static func defaultAround(_ coordinate: CLLocationCoordinate2D, radiusKm: Double = 222) -> EarthquakeQuery {
    let degreeDelta = radiusKm / 111.0

    return EarthquakeQuery(
      minLatitude: coordinate.latitude - degreeDelta,
      maxLatitude: coordinate.latitude + degreeDelta,
      minLongitude: coordinate.longitude - degreeDelta,
      maxLongitude: coordinate.longitude + degreeDelta,
      minMagnitude: 4.0
    )
  }

}
