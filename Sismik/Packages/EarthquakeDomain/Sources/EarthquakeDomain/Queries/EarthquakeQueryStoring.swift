//
//  EarthquakeQueryStoring.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import Foundation

public protocol EarthquakeQueryStoring {
  func save(_ query: EarthquakeQuery)
  func load() -> EarthquakeQuery?
  func clear()
}
