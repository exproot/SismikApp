//
//  EarthquakeRequest.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public struct EarthquakeRequest: Sendable {
  public let latitude: Double?
  public let longitude: Double?
  public let radiusKm: Double?
  public let minMagnitude: Double?
  public let maxMagnitude: Double?
  public let startTime: Date?
  public let endTime: Date?
  public let limit: Int
  public let orderBy: String
  public let eventType: String?
  
  public init(
    latitude: Double? = nil,
    longitude: Double? = nil,
    radiusKm: Double? = nil,
    minMagnitude: Double? = nil,
    maxMagnitude: Double? = nil,
    startTime: Date? = nil,
    endTime: Date? = nil,
    limit: Int,
    orderBy: String,
    eventType: String? = nil
  ) {
    self.latitude = latitude
    self.longitude = longitude
    self.radiusKm = radiusKm
    self.minMagnitude = minMagnitude
    self.maxMagnitude = maxMagnitude
    self.startTime = startTime
    self.endTime = endTime
    self.limit = limit
    self.orderBy = orderBy
    self.eventType = eventType
  }
}
