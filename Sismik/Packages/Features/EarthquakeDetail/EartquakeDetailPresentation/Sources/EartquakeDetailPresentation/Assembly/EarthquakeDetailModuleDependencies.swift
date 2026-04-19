//
//  EarthquakeDetailModuleDependencies.swift
//  EarthquakeDetail
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import Foundation

public struct EarthquakeDetailModuleDependencies {
  public let context: EarthquakeDetailContext
  
  public init(context: EarthquakeDetailContext) {
    self.context = context
  }
}
