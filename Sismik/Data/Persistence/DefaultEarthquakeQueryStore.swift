//
//  DefaultEarthquakeQueryStore.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import EarthquakeDomain
import Foundation

final class DefaultEarthquakeQueryStore: EarthquakeQueryStoring {

  private let storageKey = "earthquake.query"

  func save(_ query: EarthquakeQuery) {
    if let data = try? JSONEncoder().encode(query) {
      UserDefaults.standard.set(data, forKey: storageKey)
    }
  }
  
  func load() -> EarthquakeQuery? {
    guard let data = UserDefaults.standard.data(forKey: storageKey) else { return nil }

    return try? JSONDecoder().decode(EarthquakeQuery.self, from: data)
  }

  func clear() {
    UserDefaults.standard.removeObject(forKey: storageKey)
  }
}
