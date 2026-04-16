//
//  EarthquakeDashboardSection.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import UIKit

enum EarthquakeDashboardSection: Int, CaseIterable {
  case summary
  case recent
  case biggest
  case tip

  var title: String? {
    switch self {
    case .summary:
      return NSLocalizedString("dashboard.section.summary.header", comment: "")
    case .recent:
      return NSLocalizedString("dashboard.section.recent.header", comment: "")
    case .biggest:
      return NSLocalizedString("dashboard.section.biggest.header", comment: "")
    case .tip:
      return NSLocalizedString("dashboard.section.tip.header", comment: "")
    }
  }
}
