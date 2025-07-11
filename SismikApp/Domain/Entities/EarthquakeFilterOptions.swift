//
//  EarthquakeFilterOptions.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 10.07.2025.
//

import Foundation

struct EarthquakeFilterOptions: Equatable {
  var minMagnitude: Double
  var maxMagnitude: Double
  var radiusKm: Double
  var startDate: Date
  var endDate: Date

  static var `default`: Self {
    Self(
      minMagnitude: 4.0,
      maxMagnitude: 10.0,
      radiusKm: 222.0,
      startDate: Calendar.current.date(byAdding: .day, value: -200, to: Date())!,
      endDate: Date()
    )
  }
}
