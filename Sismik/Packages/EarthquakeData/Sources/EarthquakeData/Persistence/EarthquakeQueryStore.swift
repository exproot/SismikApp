//
//  EarthquakeQueryStore.swift
//  EarthquakeData
//
//  Created by Ertan Yağmur on 17.04.2026.
//

import EarthquakeDomain

public protocol EarthquakeQueryStore {
  func save(_ query: EarthquakeQuery)
  func load() -> EarthquakeQuery?
  func clear()
}
