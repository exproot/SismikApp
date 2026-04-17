//
//  AppPreferences.swift
//  Sismik
//
//  Created by Ertan Yağmur on 17.04.2026.
//

import Foundation

enum AppPreferences {
  static var hasSeenOnboarding: Bool {
    get { UserDefaults.standard.bool(forKey: "hasSeenOnboarding") }
    set { UserDefaults.standard.set(newValue, forKey: "hasSeenOnboarding") }
  }
}
