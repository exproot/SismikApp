//
//  EarthquakeQuery.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

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
