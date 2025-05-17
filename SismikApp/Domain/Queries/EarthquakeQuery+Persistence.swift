//
//  EarthquakeQuery+Persistence.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 18.05.2025.
//

import Foundation

extension EarthquakeQuery {

  private static let storageKey = "lastEarthquakeQuery"

  func saveToDefaults() {
    if let data = try? JSONEncoder().encode(self) {
      UserDefaults.standard.set(data, forKey: Self.storageKey)
    }
  }

  static func loadFromDefaults() -> EarthquakeQuery? {
    guard let data = UserDefaults.standard.data(forKey: storageKey) else { return nil }

    return try? JSONDecoder().decode(EarthquakeQuery.self, from: data)
  }

  static func clearDefaults() {
    UserDefaults.standard.removeObject(forKey: storageKey)
  }

}
