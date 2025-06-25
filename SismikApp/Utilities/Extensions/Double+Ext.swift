//
//  Double+Ext.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//


import SwiftUI

extension Double {
  /// Get color based on magnitude value.
  /// - Returns: A SwiftUI Color.
  func magnitudeColor() -> Color {
    switch self {
    case 0..<4:
      return .green
    case 4..<6:
      return .orange
    default:
      return .red
    }
  }

  func magnitudeColor() -> UIColor {
    switch self {
    case 0..<4:
      return .systemGreen
    case 4..<6:
      return .systemOrange
    default:
      return .systemRed
    }
  }

  func toDegreesApprox() -> Double {
    return self / 111.0
  }
}
