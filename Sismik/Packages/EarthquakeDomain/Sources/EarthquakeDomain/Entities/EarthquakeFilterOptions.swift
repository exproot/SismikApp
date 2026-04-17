//
//  EarthquakeFilterOptions.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 10.07.2025.
//

import Foundation

public struct EarthquakeFilterOptions: Equatable {
  public var minMagnitude: Double
  public var maxMagnitude: Double
  public var radiusKm: Double
  public var startDate: Date
  public var endDate: Date
  
  public init(
    minMagnitude: Double,
    maxMagnitude: Double,
    radiusKm: Double,
    startDate: Date,
    endDate: Date
  ) {
    self.minMagnitude = minMagnitude
    self.maxMagnitude = maxMagnitude
    self.radiusKm = radiusKm
    self.startDate = startDate
    self.endDate = endDate
  }

  public static var `default`: Self {
    Self(
      minMagnitude: 4.0,
      maxMagnitude: 10.0,
      radiusKm: 222.0,
      startDate: Calendar.current.date(byAdding: .day, value: -200, to: Date())!,
      endDate: Date()
    )
  }
}
