//
//  EarthquakeRequest+Ext.swift
//  Sismik
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import EarthquakeRemote
import Foundation

extension EarthquakeRequest {
  init(query: EarthquakeQuery) {
    self.init(
      latitude: query.latitude,
      longitude: query.longitude,
      radiusKm: query.radiusKm,
      minMagnitude: query.minMagnitude,
      maxMagnitude: query.maxMagnitude,
      startTime: query.startTime,
      endTime: query.endTime,
      limit: query.limit,
      orderBy: query.orderBy,
      eventType: query.eventType
    )
  }
}
