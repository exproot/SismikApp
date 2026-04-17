//
//  EarthquakeDashboardItem.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import EarthquakeDomain
import UIKit

enum EarthquakeDashboardItem: Hashable {
  case summary(EarthquakeDashboardSummaryItem)
  case recent(Earthquake)
  case biggest(Earthquake)
  case tip(String)
  case recentPlaceholder(String)
  case biggestPlaceholder(String)
}
