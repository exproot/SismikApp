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
    return EarthquakeQuery(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
      radiusKm: radiusKm,
      minMagnitude: 4.0,
      maxMagnitude: 10.0,
      startTime: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
      endTime: Date()
    )
  }

}
