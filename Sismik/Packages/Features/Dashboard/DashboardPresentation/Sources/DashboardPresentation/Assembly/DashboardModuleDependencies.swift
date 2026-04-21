//
//  DashboardModuleDependencies.swift
//  DashboardPresentation
//
//  Created by Ertan Yağmur on 18.04.2026.
//

import EarthquakeDomain
import LocationServices
import UIKit

public struct DashboardModuleDependencies {
  
  public let earthquakeRepository: EarthquakeRepositoryProtocol
  public let enricher: EarthquakeEnriching
  public let makeLocationStateController: () -> LocationStateControlling
  
  public init(
    earthquakeRepository: EarthquakeRepositoryProtocol,
    enricher: EarthquakeEnriching,
    makeLocationStateController: @escaping () -> LocationStateControlling
  ) {
    self.earthquakeRepository = earthquakeRepository
    self.enricher = enricher
    self.makeLocationStateController = makeLocationStateController
  }
  
}


