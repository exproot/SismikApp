//
//  EarthquakeQueryStoring.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import Foundation

protocol EarthquakeQueryStoring {
  func save(_ query: EarthquakeQuery)
  func load() -> EarthquakeQuery?
  func clear()
}
