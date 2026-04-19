//
//  DashboardViewModelActions.swift
//  DashboardPresentation
//
//  Created by Ertan Yağmur on 18.04.2026.
//

import CoreLocation
import EarthquakeDomain

struct DashboardViewModelActions {
  let didSelectEarthquake: (Earthquake) -> Void
  let showLocationDenied: () -> Void
}
