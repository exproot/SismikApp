//
//  ExploreViewModelActions.swift
//  ExplorePresentation
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import CoreLocation
import EarthquakeDomain

struct ExploreViewModelActions {
  let didSelectEarthquake: (Earthquake) -> Void
  let didRequestMap: ([Earthquake], Double, CLLocationCoordinate2D) -> Void
  let didRequestFilter: (EarthquakeFilterOptions) -> Void
}
