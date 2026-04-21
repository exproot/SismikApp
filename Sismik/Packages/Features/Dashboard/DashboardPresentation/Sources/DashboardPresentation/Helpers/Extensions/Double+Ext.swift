//
//  Double+Ext.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import UIKit

extension Double {
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
}
