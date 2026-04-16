//
//  EarthquakeQuery.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import CoreLocation
import Foundation

struct EarthquakeQuery: Codable, Equatable, Hashable {
  var latitude: Double?
  var longitude: Double?
  var radiusKm: Double?
  var minMagnitude: Double?
  var maxMagnitude: Double?
  var startTime: Date?
  var endTime: Date?
  var eventType: String? = "earthquake"
  var limit: Int = 50
  var orderBy: String = "time"
}

extension EarthquakeQuery {
  static func defaultAround(_ coordinate: CLLocationCoordinate2D, radiusKm: Double = 222) -> EarthquakeQuery {
    return EarthquakeQuery(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
      radiusKm: radiusKm + 200,
      minMagnitude: 4.0,
      maxMagnitude: 10.0,
      startTime: Calendar.current.date(byAdding: .day, value: -24, to: Date()),
      endTime: Date()
    )
  }
}
