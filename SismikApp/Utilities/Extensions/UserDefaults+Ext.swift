//
//  UserDefaults+Ext.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//


import SwiftUI

extension UserDefaults {
  var hasSeenOnboarding: Bool {
    get { bool(forKey: "hasSeenOnboarding") }
    set { set(newValue, forKey: "hasSeenOnboarding") }
  }
}