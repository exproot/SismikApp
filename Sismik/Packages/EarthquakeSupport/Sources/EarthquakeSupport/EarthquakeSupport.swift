// The Swift Programming Language
// https://docs.swift.org/swift-book

import EarthquakeDomain

public protocol EarthquakeQueryStore {
  func save(_ query: EarthquakeQuery)
  func load() -> EarthquakeQuery?
  func clear()
}
