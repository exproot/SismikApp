//
//  MapModuleDependencies.swift
//  MapPresentation
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import Foundation

public struct MapModuleDependencies {
  public let context: EarthquakeMapContext
  
  public init(context: EarthquakeMapContext) {
    self.context = context
  }
}
