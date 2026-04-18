//
//  DashboardViewModelActions.swift
//  DashboardPresentation
//
//  Created by Ertan Yağmur on 18.04.2026.
//

import EarthquakeDomain

public struct DashboardViewModelActions {
  public let didSelectEarthquake: (Earthquake) -> Void
  public let showLocationDenied: () -> Void
  
  public init(
    didSelectEarthquake: @escaping (Earthquake) -> Void,
    showLocationDenied: @escaping () -> Void
  ) {
    self.didSelectEarthquake = didSelectEarthquake
    self.showLocationDenied = showLocationDenied
  }
}
