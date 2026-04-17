//
//  EarthquakeQuery.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import CoreLocation
import Foundation

public struct EarthquakeQuery: Codable, Equatable, Hashable {
  public var latitude: Double?
  public var longitude: Double?
  public var radiusKm: Double?
  public var minMagnitude: Double?
  public var maxMagnitude: Double?
  public var startTime: Date?
  public var endTime: Date?
  public var eventType: String?
  public var limit: Int
  public var orderBy: String
  
  public init(
    latitude: Double? = nil,
    longitude: Double? = nil,
    radiusKm: Double? = nil,
    minMagnitude: Double? = nil,
    maxMagnitude: Double? = nil,
    startTime: Date? = nil,
    endTime: Date? = nil,
    eventType: String? = "earthquake",
    limit: Int = 50,
    orderBy: String = "time"
  ) {
    self.latitude = latitude
    self.longitude = longitude
    self.radiusKm = radiusKm
    self.minMagnitude = minMagnitude
    self.maxMagnitude = maxMagnitude
    self.startTime = startTime
    self.endTime = endTime
    self.eventType = eventType
    self.limit = limit
    self.orderBy = orderBy
  }
}

public extension EarthquakeQuery {
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
