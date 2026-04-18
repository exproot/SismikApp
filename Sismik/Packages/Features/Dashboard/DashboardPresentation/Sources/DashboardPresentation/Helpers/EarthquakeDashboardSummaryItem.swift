//
//  EarthquakeDashboardSummaryItem.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.06.2025.
//

import EarthquakeDomain
import UIKit

struct EarthquakeDashboardSummaryItem: Hashable {
  let totalCount: Int
  let averageMagnitude: Double
  let maxDepth: Double

  static func make(from earthquakes: [Earthquake]) -> EarthquakeDashboardSummaryItem {
    let total = earthquakes.count
    let avgMagnitude = earthquakes.map(\.magnitude).average
    let maxDepth = earthquakes.map(\.depth).max() ?? 0.0

    return EarthquakeDashboardSummaryItem(
      totalCount: total,
      averageMagnitude: avgMagnitude,
      maxDepth: maxDepth
    )
  }
}

enum EarthquakeTips {
  static let tips: [String] = [
    NSLocalizedString("dashboard.tip.stay.away.windows", comment: ""),
    NSLocalizedString("dashboard.tip.keep.emergency.kit", comment: ""),
    NSLocalizedString("dashboard.tip.drop.cover.hold", comment: ""),
    NSLocalizedString("dashboard.tip.identify.safe.spots", comment: ""),
    NSLocalizedString("dashboard.tip.have.family.plan", comment: "")
  ]

  static func randomTip() -> String {
    tips.randomElement() ?? ""
  }
}

extension Sequence where Element == Double {
  var average: Double {
    let values = Array(self)
    guard !values.isEmpty else { return 0.0 }
    return values.reduce(0.0, +) / Double(values.count)
  }
}
