//
//  EarthquakeExploreViewState.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import EarthquakeDomain
import Foundation

enum EarthquakeExploreViewState {
  case loading
  case loaded([EnrichedEarthquake])
  case empty
  case error(String)
}
