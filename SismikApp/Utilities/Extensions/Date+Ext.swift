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
    formatter.dateStyle = .medium
    formatter.timeStyle = .short

    return "Time: \(formatter.string(from: self))"
  }
}