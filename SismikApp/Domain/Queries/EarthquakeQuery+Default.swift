//
//  EarthquakeQuery+Default.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//


import CoreLocation
import Foundation

extension EarthquakeQuery {

  static func defaultAround(_ coordinate: CLLocationCoordinate2D) -> EarthquakeQuery {
    let delta = 2.0

    return EarthquakeQuery(
      minLatitude: coordinate.latitude - delta,
      maxLatitude: coordinate.latitude + delta,
      minLongitude: coordinate.longitude - delta,
      maxLongitude: coordinate.longitude + delta,
      minMagnitude: 5.0
    )
  }

}
