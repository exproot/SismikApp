//
//  Date+Ext.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Foundation

extension Date {
  func formatEarthquakeDate() -> String {
    let formatter = DateFormatter()

    formatter.dateFormat =  NSLocalizedString("explore.dateFormat", comment: "")
    return "\(NSLocalizedString("explore.time", comment: "")): \(formatter.string(from: self))"
  }

  func timeAgoString() -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .short
    return formatter.localizedString(for: self, relativeTo: Date())
  }
}
