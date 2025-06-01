//
//  Date+Ext.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//


import SwiftUI

extension Date {
  func formatEarthquakeDate() -> String {
    let formatter = DateFormatter()

    formatter.dateFormat =  NSLocalizedString("earthquakes.dateFormat", comment: "")
    return "\(NSLocalizedString("earthquakes.time", comment: "")): \(formatter.string(from: self))"
  }
}
